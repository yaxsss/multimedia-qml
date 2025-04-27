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

// 该着色器实现了一个浮雕效果，通过计算相邻像素的差值来创建立体感

// 基于 http://kodemongki.blogspot.com/2011/06/kameraku-custom-shader-effects-example.html

// 输入参数
uniform float dividerValue;   // 分割线位置（用于对比效果）

// 采样步长（用于确定相邻像素的采样位置）
const float step_w = 0.0015625;  // 水平方向步长
const float step_h = 0.0027778;  // 垂直方向步长

// 纹理采样器和不透明度
uniform sampler2D source;     // 输入纹理
uniform lowp float qt_Opacity;// 全局不透明度
varying vec2 qt_TexCoord0;    // 纹理坐标

void main()
{
    // 获取当前纹理坐标
    vec2 uv = qt_TexCoord0.xy;
    
    // 采样3x3网格内的9个像素点
    // t1 t2 t3
    // t4 t5 t6
    // t7 t8 t9
    vec3 t1 = texture2D(source, vec2(uv.x - step_w, uv.y - step_h)).rgb;  // 左上
    vec3 t2 = texture2D(source, vec2(uv.x, uv.y - step_h)).rgb;           // 上
    vec3 t3 = texture2D(source, vec2(uv.x + step_w, uv.y - step_h)).rgb;  // 右上
    vec3 t4 = texture2D(source, vec2(uv.x - step_w, uv.y)).rgb;           // 左
    vec3 t5 = texture2D(source, uv).rgb;                                   // 中心
    vec3 t6 = texture2D(source, vec2(uv.x + step_w, uv.y)).rgb;           // 右
    vec3 t7 = texture2D(source, vec2(uv.x - step_w, uv.y + step_h)).rgb;  // 左下
    vec3 t8 = texture2D(source, vec2(uv.x, uv.y + step_h)).rgb;           // 下
    vec3 t9 = texture2D(source, vec2(uv.x + step_w, uv.y + step_h)).rgb;  // 右下
    
    // 计算浮雕效果
    // 使用类似拉普拉斯算子的卷积核：
    // -4 -4 0
    // -4 12 0
    //  0  0 0
    vec3 rr = -4.0 * t1 - 4.0 * t2 - 4.0 * t4 + 12.0 * t5;
    
    // 转换为灰度值
    float y = (rr.r + rr.g + rr.b) / 3.0;
    
    // 调整亮度并创建最终颜色
    vec3 col = vec3(y, y, y) + 0.3;  // 加0.3是为了提亮整体效果
    
    // 根据dividerValue分割显示原始图像和浮雕效果
    if (uv.x < dividerValue)
        gl_FragColor = qt_Opacity * vec4(col, 1.0);    // 显示浮雕效果
    else
        gl_FragColor = qt_Opacity * texture2D(source, uv); // 显示原始图像
}
