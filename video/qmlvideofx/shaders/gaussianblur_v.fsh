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

// 垂直方向的高斯模糊着色器
// 使用9个采样点实现一维高斯模糊
// 与水平方向的高斯模糊配合使用，实现完整的二维高斯模糊效果

// 输入参数
uniform float dividerValue;   // 分割线位置（用于对比效果）
uniform float blurSize;       // 模糊大小（采样间距）, 控制模糊范围

// 纹理采样器和不透明度
uniform sampler2D source;     // 输入纹理
uniform lowp float qt_Opacity;// 全局不透明度（本次处理不使用）
varying vec2 qt_TexCoord0;    // 纹理坐标

void main()
{
    // 获取当前纹理坐标
    vec2 uv = qt_TexCoord0.xy;
    // 初始化颜色累加器
    vec4 c = vec4(0.0);
    
    // 根据dividerValue分割显示原始图像和模糊效果
    if (uv.x < dividerValue) {
        // 应用垂直高斯模糊
        // 使用9个采样点，权重按照高斯分布设置
        // 权重总和为1.0，确保亮度保持不变
        
        // 上方4个采样点
        c += texture2D(source, uv - vec2(0.0, 4.0*blurSize)) * 0.05;  // 权重0.05
        c += texture2D(source, uv - vec2(0.0, 3.0*blurSize)) * 0.09;  // 权重0.09
        c += texture2D(source, uv - vec2(0.0, 2.0*blurSize)) * 0.12;  // 权重0.12
        c += texture2D(source, uv - vec2(0.0, 1.0*blurSize)) * 0.15;  // 权重0.15
        
        // 中心点
        c += texture2D(source, uv) * 0.18;                            // 权重0.18
        
        // 下方4个采样点
        c += texture2D(source, uv + vec2(0.0, 1.0*blurSize)) * 0.15;  // 权重0.15
        c += texture2D(source, uv + vec2(0.0, 2.0*blurSize)) * 0.12;  // 权重0.12
        c += texture2D(source, uv + vec2(0.0, 3.0*blurSize)) * 0.09;  // 权重0.09
        c += texture2D(source, uv + vec2(0.0, 4.0*blurSize)) * 0.05;  // 权重0.05
    } else {
        // 显示原始图像
        c = texture2D(source, qt_TexCoord0);
    }
    
    // 第一次处理不应用不透明度
    // 因为这是两步高斯模糊中的第一步
    gl_FragColor = c;
}
