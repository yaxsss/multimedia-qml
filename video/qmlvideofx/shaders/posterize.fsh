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

// 这个着色器实现了一个色调分离（posterization）效果
// 通过减少图像中的颜色数量，创造出类似海报的艺术效果
// 基于 http://www.geeks3d.com/20091027/shader-library-posterization-post-processing-effect-glsl/

// 输入参数
uniform float dividerValue;   // 分割线位置（用于对比效果）
uniform float gamma;          // gamma值，用于调整颜色空间
uniform float numColors;      // 目标颜色数量，控制色调分离程度

// 纹理采样器和不透明度
uniform sampler2D source;     // 输入纹理
uniform lowp float qt_Opacity;// 全局不透明度
varying vec2 qt_TexCoord0;    // 纹理坐标

void main()
{
    // 获取当前纹理坐标
    vec2 uv = qt_TexCoord0.xy;
    // 初始化输出颜色
    vec4 c = vec4(0.0);
    
    // 在分割线左侧应用色调分离效果
    if (uv.x < dividerValue) {
        // 获取原始RGB颜色
        vec3 x = texture2D(source, uv).rgb;
        
        // 应用gamma校正，将颜色空间转换为线性空间
        x = pow(x, vec3(gamma, gamma, gamma));
        
        // 将颜色值缩放到目标颜色数量范围
        x = x * numColors;
        
        // 对颜色值取整，创造离散的色阶
        x = floor(x);
        
        // 将颜色值归一化回[0,1]范围
        x = x / numColors;
        
        // 应用逆gamma校正，将颜色空间转回显示空间
        x = pow(x, vec3(1.0/gamma));
        
        // 设置alpha通道为1.0
        c = vec4(x, 1.0);
    } else {
        // 分割线右侧显示原始图像
        c = texture2D(source, uv);
    }
    
    // 应用全局不透明度并输出最终颜色
    gl_FragColor = qt_Opacity * c;
}
