/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Mobility Components.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "frequencymonitor.h"
#include <QDebug>
#include <QElapsedTimer>
#include <QString>
#include <QTime>
#include <QTimer>

//#define VERBOSE_TRACE

inline QDebug qtTrace() { return qDebug() << "[frequencymonitor]"; }
#ifdef VERBOSE_TRACE
inline QDebug qtVerboseTrace() { return qtTrace(); }
#else
inline QNoDebug qtVerboseTrace() { return QNoDebug(); }
#endif

// 默认采样间隔时间（毫秒）
static const int DefaultSamplingInterval = 100;
// 默认跟踪间隔时间（毫秒）
static const int DefaultTraceInterval = 0;

class FrequencyMonitorPrivate : public QObject
{
    Q_OBJECT

public:
    FrequencyMonitorPrivate(FrequencyMonitor *parent);
    // 计算瞬时频率
    void calculateInstantaneousFrequency();

private slots:
    // 计算平均频率
    void calculateAverageFrequency();
    // 处理停滞状态（当一段时间内没有新事件时）
    void stalled();

public:
    FrequencyMonitor *const q_ptr;          // 指向公共类的指针
    QString m_label;                        // 监视器标签
    bool m_active;                          // 是否处于活动状态
    qreal m_instantaneousFrequency;         // 瞬时频率
    QElapsedTimer m_instantaneousElapsed;   // 瞬时频率计时器
    QTimer *m_averageTimer;                 // 平均频率计算定时器
    QElapsedTimer m_averageElapsed;         // 平均频率计时器
    int m_count;                            // 采样周期内的事件计数
    qreal m_averageFrequency;               // 平均频率
    QTimer *m_traceTimer;                   // 跟踪输出定时器
    QTimer *m_stalledTimer;                 // 停滞检测定时器
};

FrequencyMonitorPrivate::FrequencyMonitorPrivate(FrequencyMonitor *parent)
:   QObject(parent)
,   q_ptr(parent)
,   m_active(false)
,   m_instantaneousFrequency(0)
,   m_averageTimer(new QTimer(this))
,   m_count(0)
,   m_averageFrequency(0)
,   m_traceTimer(new QTimer(this))
,   m_stalledTimer(new QTimer(this))
{
    m_instantaneousElapsed.start();
    connect(m_averageTimer, &QTimer::timeout,
            this, &FrequencyMonitorPrivate::calculateAverageFrequency);
    if (DefaultSamplingInterval)
        m_averageTimer->start(DefaultSamplingInterval);
    m_averageElapsed.start();
    connect(m_traceTimer, &QTimer::timeout,
            q_ptr, &FrequencyMonitor::trace);
    if (DefaultTraceInterval)
        m_traceTimer->start(DefaultTraceInterval);
    m_stalledTimer->setSingleShot(true);
    connect(m_stalledTimer, &QTimer::timeout,
            this, &FrequencyMonitorPrivate::stalled);
}

void FrequencyMonitorPrivate::calculateInstantaneousFrequency()
{
    // 计算自上次事件以来经过的毫秒数
    const qint64 ms = m_instantaneousElapsed.restart();
    // 计算瞬时频率（次/秒）
    m_instantaneousFrequency = ms ? qreal(1000) / ms : 0;
    // 设置停滞检测定时器，超时时间为事件间隔的3倍
    m_stalledTimer->start(3 * ms);
    if (m_instantaneousFrequency)
        q_ptr->setActive(true);
    // 发出频率变化信号
    emit q_ptr->instantaneousFrequencyChanged(m_instantaneousFrequency);
    emit q_ptr->frequencyChanged();
}

void FrequencyMonitorPrivate::calculateAverageFrequency()
{
    // 计算采样周期内经过的毫秒数
    const qint64 ms = m_averageElapsed.restart();
    // 计算平均频率（次/秒）
    m_averageFrequency = qreal(m_count * 1000) / ms;
    // 发出频率变化信号
    emit q_ptr->averageFrequencyChanged(m_averageFrequency);
    emit q_ptr->frequencyChanged();
    // 重置计数器
    m_count = 0;
}

void FrequencyMonitorPrivate::stalled()
{
    // 如果当前有瞬时频率，将其设置为0并发出信号
    if (m_instantaneousFrequency) {
        m_instantaneousFrequency = 0;
        emit q_ptr->instantaneousFrequencyChanged(m_instantaneousFrequency);
        emit q_ptr->frequencyChanged();
    }
}

FrequencyMonitor::FrequencyMonitor(QObject *parent)
:   QObject(parent)
{
    d_ptr = new FrequencyMonitorPrivate(this);
}

FrequencyMonitor::~FrequencyMonitor()
{

}

QString FrequencyMonitor::label() const
{
    return d_func()->m_label;
}

bool FrequencyMonitor::active() const
{
    return d_func()->m_active;
}

int FrequencyMonitor::samplingInterval() const
{
    return d_ptr->m_averageTimer->isActive() ? d_ptr->m_averageTimer->interval() : 0;
}

int FrequencyMonitor::traceInterval() const
{
    return d_ptr->m_traceTimer->isActive() ? d_ptr->m_traceTimer->interval() : 0;
}

qreal FrequencyMonitor::instantaneousFrequency() const
{
    return d_func()->m_instantaneousFrequency;
}

qreal FrequencyMonitor::averageFrequency() const
{
    return d_func()->m_averageFrequency;
}

void FrequencyMonitor::notify()
{
    Q_D(FrequencyMonitor);
    // 增加事件计数
    ++(d->m_count);
    // 计算新的瞬时频率
    d->calculateInstantaneousFrequency();
}

void FrequencyMonitor::trace()
{
    Q_D(FrequencyMonitor);
    // 格式化输出当前的频率信息
    const QString value = QString::fromLatin1("instant %1 average %2")
                            .arg(d->m_instantaneousFrequency, 0, 'f', 2)
                            .arg(d->m_averageFrequency, 0, 'f', 2);
    if (d->m_label.isEmpty())
        qtTrace() << "FrequencyMonitor::trace" << value;
    else
        qtTrace() << "FrequencyMonitor::trace" << "label" << d->m_label << value;
}

void FrequencyMonitor::setLabel(const QString &value)
{
    Q_D(FrequencyMonitor);
    if (d->m_label != value) {
        d->m_label = value;
        emit labelChanged(d->m_label);
    }
}

void FrequencyMonitor::setActive(bool value)
{
    Q_D(FrequencyMonitor);
    if (d->m_active != value) {
        d->m_active = value;
        emit activeChanged(d->m_active);
    }
}

void FrequencyMonitor::setSamplingInterval(int value)
{
    Q_D(FrequencyMonitor);
    if (samplingInterval() != value) {
        if (value) {
            // 设置新的采样间隔并启动定时器
            d->m_averageTimer->setInterval(value);
            d->m_averageTimer->start();
        } else {
            // 停止采样
            d->m_averageTimer->stop();
        }
        emit samplingIntervalChanged(value);
    }
}

void FrequencyMonitor::setTraceInterval(int value)
{
    Q_D(FrequencyMonitor);
    if (traceInterval() != value) {
        if (value) {
            // 设置新的跟踪间隔并启动定时器
            d->m_traceTimer->setInterval(value);
            d->m_traceTimer->start();
        } else {
            // 停止跟踪
            d->m_traceTimer->stop();
        }
        emit traceIntervalChanged(value);
    }
}

#include "frequencymonitor.moc"
