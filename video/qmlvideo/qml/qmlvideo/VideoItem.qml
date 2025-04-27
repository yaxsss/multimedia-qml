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
import QtMultimedia 5.0

// VideoOutput组件用于显示视频内容
VideoOutput {
    id: root
    height: width  // 保持视频输出区域为正方形
    source: mediaPlayer  // 视频源为mediaPlayer

    // 属性别名，将MediaPlayer的属性暴露给外部
    property alias duration: mediaPlayer.duration          // 视频总时长
    property alias mediaSource: mediaPlayer.source        // 视频源地址
    property alias metaData: mediaPlayer.metaData         // 视频元数据
    property alias playbackRate: mediaPlayer.playbackRate // 播放速率
    property alias position: mediaPlayer.position         // 当前播放位置
    property alias volume: mediaPlayer.volume             // 音量大小

    // 自定义信号
    signal sizeChanged  // 尺寸改变信号
    signal fatalError   // 致命错误信号

    // 当高度改变时触发sizeChanged信号
    onHeightChanged: root.sizeChanged()

    // 媒体播放器组件
    MediaPlayer {
        id: mediaPlayer
        autoLoad: false           // 禁用自动加载
        loops: Audio.Infinite     // 无限循环播放

        // 错误处理
        onError: {
            if (MediaPlayer.NoError != error) {
                console.log("[qmlvideo] VideoItem.onError error " + error + " errorString " + errorString)
                root.fatalError()
            }
        }
    }

    // 公共方法
    function start() { mediaPlayer.play() }    // 开始播放
    function stop() { mediaPlayer.stop() }     // 停止播放
    function seek(position) { mediaPlayer.seek(position); }  // 跳转到指定位置
}
