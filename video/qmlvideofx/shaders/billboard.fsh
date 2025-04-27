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
// 实现了一个广告牌效果
// 将图像按网格划分，对每个网格进行像素化处理
// 计算并量化图像亮度，应用亮度调整效果
// 在网格边界创建线条效果，使用平滑过渡使线条更自然
// 基于 http://kodemongki.blogspot.com/2011/06/kameraku-custom-shader-effects-example.html

// 输入参数
uniform float grid;           // 网格大小
uniform float dividerValue;   // 分割线位置（用于对比效果）
uniform float step_x;         // X方向步长
uniform float step_y;         // Y方向步长

// 纹理采样器和不透明度
uniform sampler2D source;     // 输入纹理
uniform lowp float qt_Opacity;// 全局不透明度
varying vec2 qt_TexCoord0;    // 纹理坐标

void main()
{
    // 获取当前纹理坐标
    vec2 uv = qt_TexCoord0.xy;
    
    // 计算网格偏移量，使用floor函数进行离散化
    float offx = floor(uv.x  / (grid * step_x));
    float offy = floor(uv.y  / (grid * step_y));
    
    // 对网格采样，创建像素化效果
    vec3 res = texture2D(source, vec2(offx * grid * step_x , offy * grid * step_y)).rgb;
    
    // 计算在网格内的相对位置
    vec2 prc = fract(uv / vec2(grid * step_x, grid * step_y));
    
    // 计算到网格中心的距离
    vec2 pw = pow(abs(prc - 0.5), vec2(2.0));
    
    // 设置网格线的半径
    float rs = pow(0.45, 2.0);
    
    // 使用smoothstep创建网格线效果
    float gr = smoothstep(rs - 0.1, rs + 0.1, pw.x + pw.y);
    
    // 计算亮度值
    float y = (res.r + res.g + res.b) / 3.0;
    
    // 计算颜色比例
    vec3 ra = res / y;
    
    // 亮度量化参数
    float ls = 0.3;
    float lb = ceil(y / ls);
    float lf = ls * lb + 0.3;
    
    // 应用亮度量化
    res = lf * res;
    
    // 混合网格线效果
    vec3 col = mix(res, vec3(0.1, 0.1, 0.1), gr);
    
    // 根据dividerValue分割显示原始图像和效果图像
    if (uv.x < dividerValue)
        gl_FragColor = qt_Opacity * vec4(col, 1.0);        // 显示效果图像
    else
        gl_FragColor = qt_Opacity * texture2D(source, uv); // 显示原始图像
}
