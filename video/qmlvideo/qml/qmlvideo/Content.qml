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

// 内容显示容器组件
Rectangle {
    id: root
    border.color: "white"                    // 边框颜色
    border.width: showBorder ? 1 : 0         // 边框宽度，根据showBorder决定是否显示
    color: "transparent"                      // 背景透明

    // 基本属性
    property string contentType              // 内容类型："camera"或"video"
    property string source                   // 媒体源
    property real volume                     // 音量
    property bool dummy: false               // 是否使用替代组件
    property bool autoStart: true            // 是否自动开始播放
    property bool started: false             // 是否已开始播放
    property bool showFrameRate: false       // 是否显示帧率
    property bool showBorder: false          // 是否显示边框

    // 信号定义
    signal initialized                       // 初始化完成信号
    signal error                            // 错误信号
    signal videoFramePainted                // 视频帧绘制完成信号

    // 内容加载器
    Loader {
        id: contentLoader                    // 用于动态加载视频或相机组件
    }

    // 帧绘制信号连接
    Connections {
        id: framePaintedConnection
        function onFramePainted() {
            if (frameRateLoader.item)
                frameRateLoader.item.notify()    // 更新帧率显示
            root.videoFramePainted()             // 触发帧绘制信号
        }
        ignoreUnknownSignals: true
    }

    // 错误信号连接
    Connections {
        id: errorConnection
        function onFatalError() {
            console.log("[qmlvideo] Content.onFatalError")
            root.stop()                          // 停止播放
            root.error()                         // 触发错误信号
        }
        ignoreUnknownSignals: true
    }

    // 帧率显示加载器
    Loader {
        id: frameRateLoader
        source: root.showFrameRate ? "../frequencymonitor/FrequencyItem.qml" : ""
        onLoaded: {
            item.parent = root
            item.anchors.top = root.top
            item.anchors.right = root.right
            item.anchors.margins = 10
        }
    }

    // 尺寸变化处理
    onWidthChanged: {
        if (contentItem())
            contentItem().width = width
    }

    onHeightChanged: {
        if (contentItem())
            contentItem().height = height
    }

    // 初始化函数
    function initialize() {
        if ("video" == contentType) {
            // 加载视频组件
            contentLoader.source = "VideoItem.qml"
            if (Loader.Error == contentLoader.status) {
                // 如果加载失败，使用替代组件
                contentLoader.source = "VideoDummy.qml"
                dummy = true
            }
            contentLoader.item.volume = volume
        } else if ("camera" == contentType) {
            // 加载相机组件
            contentLoader.source = "CameraItem.qml"
            if (Loader.Error == contentLoader.status) {
                // 如果加载失败，使用替代组件
                contentLoader.source = "CameraDummy.qml"
                dummy = true
            }
        } else {
            console.log("[qmlvideo] Content.initialize: error: invalid contentType")
        }

        // 设置组件属性和连接信号
        if (contentLoader.item) {
            contentLoader.item.sizeChanged.connect(updateRootSize)
            contentLoader.item.parent = root
            contentLoader.item.width = root.width
            framePaintedConnection.target = contentLoader.item
            errorConnection.target = contentLoader.item
            if (root.autoStart)
                root.start()
        }
        root.initialized()
    }

    // 开始播放
    function start() {
        if (contentLoader.item) {
            if (root.contentType == "video")
                contentLoader.item.mediaSource = root.source
            contentLoader.item.start()
            root.started = true
        }
    }

    // 停止播放
    function stop() {
        if (contentLoader.item) {
            contentLoader.item.stop()
            if (root.contentType == "video")
                contentLoader.item.mediaSource = ""
            root.started = false
        }
    }

    // 工具函数
    function contentItem() { return contentLoader.item }           // 获取当前内容项
    function updateRootSize() { root.height = contentItem().height }  // 更新根组件尺寸
}
