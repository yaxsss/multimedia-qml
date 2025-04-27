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

// 这个着色器实现了一个动态波纹效果
// 基于Qt博客文章: http://blog.qt.io/blog/2011/03/22/the-convenient-power-of-qml-scene-graph/

// 基础参数
uniform float dividerValue;    // 分割线位置，用于对比效果
uniform float targetWidth;     // 目标纹理宽度
uniform float targetHeight;    // 目标纹理高度
uniform float time;           // 时间参数，用于动画

// 纹理和不透明度参数
uniform sampler2D source;     // 输入纹理
uniform lowp float qt_Opacity;// 全局不透明度
varying vec2 qt_TexCoord0;    // 纹理坐标

// 波纹效果参数
const float PI = 3.1415926535;// PI常量
const int ITER = 7;           // 迭代次数，影响波纹的复杂度
const float RATE = 0.1;       // 波纹移动速率
uniform float amplitude;      // 波纹振幅
uniform float n;             // 波纹频率
uniform float pixDens;       // 像素密度，影响波纹的精细程度

void main()
{
    // 获取纹理坐标
    vec2 uv = qt_TexCoord0.xy;
    vec2 tc = uv;
    
    // 计算归一化的像素坐标，考虑像素密度的偏移
    vec2 p = vec2(-1.0 + 2.0 * (gl_FragCoord.x - (pixDens * 14.0)) / targetWidth, 
                  -(-1.0 + 2.0 * (gl_FragCoord.y - (pixDens * 29.0)) / targetHeight));
    
    // 初始化位移累加器
    float diffx = 0.0;
    float diffy = 0.0;
    
    // 在分割线左侧应用波纹效果
    if (uv.x < dividerValue) {
        // 通过多次迭代计算波纹效果
        for (int i=0; i<ITER; ++i) {
            // 计算当前迭代的角度
            float theta = float(i) * PI / float(ITER);
            
            // 对坐标进行旋转变换
            vec2 r = vec2(cos(theta) * p.x + sin(theta) * p.y, 
                         -1.0 * sin(theta) * p.x + cos(theta) * p.y);
            
            // 计算波纹扰动
            float diff = (sin(2.0 * PI * n * (r.y + time * RATE)) + 1.0) / 2.0;
            
            // 累加x和y方向的扰动
            diffx += diff * sin(theta);
            diffy += diff * cos(theta);
        }
        
        // 应用最终的坐标扰动
        tc = 0.5*(vec2(1.0,1.0) + p) + amplitude * vec2(diffx, diffy);
    }
    
    // 输出最终颜色，应用全局不透明度
    gl_FragColor = qt_Opacity * texture2D(source, tc);
}
