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

// 这个着色器实现了一个像素化效果，可以将图像分割成大小可调的像素块
// 基于 http://www.geeks3d.com/20101029/shader-library-pixelation-post-processing-effect-glsl/

// 输入参数
uniform float dividerValue;   // 分割线位置（用于对比效果）
uniform float granularity;    // 像素化粒度，控制像素块大小
uniform float targetWidth;    // 目标纹理宽度
uniform float targetHeight;   // 目标纹理高度

// 纹理采样器和不透明度
uniform sampler2D source;     // 输入纹理
uniform lowp float qt_Opacity;// 全局不透明度
varying vec2 qt_TexCoord0;    // 纹理坐标

void main()
{
    // 获取当前纹理坐标
    vec2 uv = qt_TexCoord0.xy;
    // 用于最终采样的纹理坐标
    vec2 tc = qt_TexCoord0;
    
    // 在分割线左侧且粒度大于0时应用像素化效果
    if (uv.x < dividerValue && granularity > 0.0) {
        // 计算X和Y方向上的像素块大小
        float dx = granularity / targetWidth;   // X方向像素块宽度
        float dy = granularity / targetHeight;  // Y方向像素块高度
        
        // 计算像素化后的采样坐标
        // floor(uv.x/dx)：将坐标离散化为块索引
        // + 0.5：将采样点移到块的中心
        // * dx/dy：转换回纹理坐标
        tc = vec2(dx*(floor(uv.x/dx) + 0.5),    // X坐标像素化
                 dy*(floor(uv.y/dy) + 0.5));     // Y坐标像素化
    }
    
    // 使用计算出的纹理坐标采样并输出最终颜色
    gl_FragColor = qt_Opacity * texture2D(source, tc);
}
