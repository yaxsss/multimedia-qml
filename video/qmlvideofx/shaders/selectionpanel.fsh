/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd and/or its subsidiary(-ies).
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

// 这个着色器用于实现视频效果选择面板的视觉效果
// 主要用于在效果列表中创建平滑的过渡和视觉反馈

// 基础参数
uniform sampler2D source;      // 输入纹理
uniform lowp float qt_Opacity; // 全局不透明度
varying vec2 qt_TexCoord0;     // 纹理坐标

// 选择面板参数
uniform float panelWidth;      // 面板宽度
uniform float panelHeight;     // 面板高度
uniform float selectedIndex;   // 当前选中项的索引
uniform float hoverIndex;      // 当前悬停项的索引

void main()
{
    // 获取当前纹理坐标
    vec2 uv = qt_TexCoord0.xy;
    
    // 获取原始颜色
    vec4 originalColor = texture2D(source, uv);
    
    // 计算当前像素所在的项索引
    float itemIndex = floor(uv.y * panelHeight);
    
    // 根据选中状态和悬停状态计算颜色
    vec4 outputColor = originalColor;
    
    // 如果是选中项
    if (abs(itemIndex - selectedIndex) < 0.5) {
        // 增加亮度和饱和度
        outputColor.rgb *= 1.2;
        outputColor.a = 1.0;
    }
    
    // 如果是悬停项
    if (abs(itemIndex - hoverIndex) < 0.5) {
        // 添加柔和的高亮效果
        outputColor.rgb = mix(outputColor.rgb, vec3(1.0), 0.2);
    }
    
    // 添加边缘渐变效果
    float edgeFade = smoothstep(0.0, 0.1, uv.x) * smoothstep(1.0, 0.9, uv.x);
    outputColor.a *= edgeFade;
    
    // 输出最终颜色
    gl_FragColor = qt_Opacity * outputColor;
}

