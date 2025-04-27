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

// 导入所需的Qt模块
import QtQuick 2.0

// 场景组件，用于展示带有半透明覆盖层的视频内容
Scene {
    id: root
    property int margin: 20        // 边距属性
    property string contentType    // 内容类型（视频/相机）

    // 主要内容显示组件
    Content {
        id: content
        anchors.centerIn: parent                   // 居中显示
        width: parent.contentWidth                 // 宽度继承自父组件
        contentType: root.contentType              // 设置内容类型
        source: parent.source1                     // 设置源
        volume: parent.volume                      // 设置音量
        onVideoFramePainted: root.videoFramePainted()  // 视频帧绘制完成时触发信号
    }

    // 半透明覆盖层
    Rectangle {
        id: overlay
        y: 0.5 * parent.height                    // 初始垂直位置
        width: content.width                       // 与内容等宽
        height: content.height                     // 与内容等高
        color: "#e0e0e0"                          // 浅灰色
        opacity: 0.5                              // 50%透明度

        // 水平方向的动画
        SequentialAnimation on x {
            id: xAnimation
            loops: Animation.Infinite              // 无限循环
            property int from: margin             // 起始位置
            property int to: 100                  // 结束位置
            property int duration: 1500           // 动画持续时间（毫秒）
            running: false                        // 初始状态不运行

            // 从左到右的动画
            PropertyAnimation {
                from: xAnimation.from
                to: xAnimation.to
                duration: xAnimation.duration
                easing.type: Easing.InOutCubic    // 缓动效果
            }
            // 从右到左的动画
            PropertyAnimation {
                from: xAnimation.to
                to: xAnimation.from
                duration: xAnimation.duration
                easing.type: Easing.InOutCubic    // 缓动效果
            }
        }

        // 垂直方向的动画
        SequentialAnimation on y {
            id: yAnimation
            loops: Animation.Infinite              // 无限循环
            property int from: margin             // 起始位置
            property int to: 180                  // 结束位置
            property int duration: 1500           // 动画持续时间（毫秒）
            running: false                        // 初始状态不运行

            // 从上到下的动画
            PropertyAnimation {
                from: yAnimation.from
                to: yAnimation.to
                duration: yAnimation.duration
                easing.type: Easing.InOutCubic    // 缓动效果
            }
            // 从下到上的动画
            PropertyAnimation {
                from: yAnimation.to
                to: yAnimation.from
                duration: yAnimation.duration
                easing.type: Easing.InOutCubic    // 缓动效果
            }
        }
    }

    // 当宽度改变时重新计算并启动水平动画
    onWidthChanged: {
        xAnimation.to = root.width - content.width - margin
        xAnimation.start()
    }

    // 当高度改变时启动垂直动画
    onHeightChanged: {
        //yAnimation.to = root.height - content.height - margin
        yAnimation.start()
    }

    // 组件完成加载时的处理
    Component.onCompleted: root.content = content
}
