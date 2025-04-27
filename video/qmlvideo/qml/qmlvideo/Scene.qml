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

// 场景基础组件，作为视频/相机内容的容器
Rectangle {
    id: root
    color: "black"                           // 背景色为黑色

    // 属性定义
    property alias buttonHeight: closeButton.height  // 关闭按钮高度
    property string source1                         // 主媒体源
    property string source2                         // 备用媒体源
    property int contentWidth: parent.width         // 内容宽度，默认继承父组件宽度
    property real volume: 0.25                      // 音量，默认为25%
    property int margins: 5                         // 边距
    property QtObject content                       // 内容对象引用

    // 信号定义
    signal close                                    // 关闭信号
    signal videoFramePainted                        // 视频帧绘制完成信号

    // 返回按钮
    Button {
        id: closeButton
        anchors {
            top: parent.top                         // 固定在顶部
            right: parent.right                     // 固定在右侧
            margins: root.margins                   // 应用边距
        }
        // 按钮尺寸计算：根据父组件尺寸动态调整
        width: Math.max(parent.width, parent.height) / 12   // 宽度为父组件最大边长的1/12
        height: Math.min(parent.width, parent.height) / 12  // 高度为父组件最小边长的1/12
        z: 2.0                                     // 置于上层
        
        // 按钮样式
        bgColor: "#212121"                         // 正常状态背景色
        bgColorSelected: "#757575"                 // 选中状态背景色
        textColorSelected: "white"                 // 选中状态文字颜色
        text: "Back"                               // 按钮文字
        
        onClicked: root.close()                    // 点击时触发场景关闭信号
    }
}
