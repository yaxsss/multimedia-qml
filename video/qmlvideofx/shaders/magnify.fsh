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

// 这个着色器实现了一个放大镜效果，模拟了透镜的光学变形效果
// 基于 http://www.reddit.com/r/programming/comments/losip/shader_toy/c2upn1e

// 纹理采样器和基本参数
uniform sampler2D source;     // 输入纹理
uniform lowp float qt_Opacity;// 全局不透明度
varying vec2 qt_TexCoord0;    // 纹理坐标

// 放大镜参数
uniform float radius;         // 放大镜半径
uniform float diffractionIndex; // 折射率，控制放大效果的强度
uniform float targetWidth;    // 目标纹理宽度
uniform float targetHeight;   // 目标纹理高度
uniform float posX;          // 放大镜中心X坐标
uniform float posY;          // 放大镜中心Y坐标
uniform float pixDens;       // 像素密度，用于调整位置偏移

void main()
{
    // 获取当前纹理坐标
    vec2 tc = qt_TexCoord0;
    
    // 放大镜中心位置
    vec2 center = vec2(posX, posY);
    
    // 计算当前像素相对于放大镜中心的偏移
    vec2 xy = gl_FragCoord.xy - center.xy;
    
    // 应用像素密度校正
    xy.x -= (pixDens * 14.0);  // X方向偏移校正
    xy.y -= (pixDens * 29.0);  // Y方向偏移校正
    
    // 计算到中心的距离
    float r = sqrt(xy.x * xy.x + xy.y * xy.y);
    
    // 如果在放大镜半径范围内，应用变形效果
    if (r < radius) {
        // 计算透镜高度（影响放大效果的强度）
        float h = diffractionIndex * 0.5 * radius;
        
        // 应用透镜变形公式
        // 使用球面透镜的光学变形模型
        // radius - h：透镜的有效焦距
        // sqrt(radius * radius - r * r)：球面透镜的曲率校正
        vec2 new_xy = r < radius ? xy * (radius - h) / sqrt(radius * radius - r * r) : xy;
        
        // 将变形后的坐标转换回纹理坐标空间
        vec2 targetSize = vec2(targetWidth, targetHeight);
        tc = (new_xy + center) / targetSize;
        
        // 翻转Y坐标（OpenGL纹理坐标系统的特性）
        tc.y = 1.0 - tc.y;
    }
    
    // 采样并输出最终颜色
    gl_FragColor = qt_Opacity * texture2D(source, tc);
}
