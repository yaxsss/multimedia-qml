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

// 这个着色器实现了一个颜色隔离效果，保留特定色相范围的彩色，其他部分转为灰度
// 基于 http://kodemongki.blogspot.com/2011/06/kameraku-custom-shader-effects-example.html

// 输入参数
uniform float targetHue;      // 目标色相值（0-360度）
uniform float windowWidth;    // 色相容差范围
uniform float dividerValue;   // 分割线位置（用于对比效果）

// 纹理采样器和不透明度
uniform sampler2D source;     // 输入纹理
uniform lowp float qt_Opacity;// 全局不透明度
varying vec2 qt_TexCoord0;    // 纹理坐标

// RGB转HSL颜色空间的函数
// 输入：rgb颜色值
// 输出：h(色相)，s(饱和度)，l(亮度)
void rgb2hsl(vec3 rgb, out float h, out float s, float l)
{
    // 找出RGB中的最大和最小值
    float maxval = max(rgb.r, max(rgb.g, rgb.b));
    float minval = min(rgb.r, min(rgb.g, rgb.b));
    float delta = maxval - minval;
    
    // 计算亮度 L = (min + max) / 2
    l = (minval + maxval) / 2.0;
    
    // 计算饱和度 S
    s = 0.0;
    if (l > 0.0 && l < 1.0)
        s = delta / (l < 0.5 ? 2.0 * l : 2.0 - 2.0 * l);
    
    // 计算色相 H
    h = 0.0;
    if (delta > 0.0)
    {
        // 根据最大值是R、G、B中的哪个来计算色相
        if (rgb.r == maxval && rgb.g != maxval)
            h += (rgb.g - rgb.b ) / delta;        // 在红-黄色区间
        if (rgb.g == maxval && rgb.b != maxval)
            h += 2.0  + (rgb.b - rgb.r) / delta;  // 在黄-绿色区间
        if (rgb.b == maxval && rgb.r != maxval)
            h += 4.0 + (rgb.r - rgb.g) / delta;   // 在绿-蓝色区间
        h *= 60.0;  // 转换到角度值(0-360度)
    }
}

void main()
{
    // 获取当前纹理坐标
    vec2 uv = qt_TexCoord0.xy;
    
    // 采样原始颜色
    vec3 col = texture2D(source, uv).rgb;
    
    // 将RGB转换到HSL空间
    float h, s, l;
    rgb2hsl(col, h, s, l);
    
    // 处理色相环绕情况（比如目标色相在0度附近）
    float h2 = (h > targetHue) ? h - 360.0 : h + 360.0;
    
    // 计算灰度值（使用BT.601标准的RGB权重）
    float y = 0.3 * col.r + 0.59 * col.g + 0.11 * col.b;
    
    vec3 result;
    // 如果是分割线右侧，或者颜色在目标色相范围内，保持原色
    // 否则转换为灰度
    if (uv.x > dividerValue || (abs(h - targetHue) < windowWidth) || (abs(h2 - targetHue) < windowWidth))
        result = col;  // 保持原始颜色
    else
        result = vec3(y, y, y);  // 转换为灰度
    
    // 输出最终颜色
    gl_FragColor = qt_Opacity * vec4(result, 1.0);
}
