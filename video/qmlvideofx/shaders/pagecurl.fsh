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

// 这个着色器实现了一个逼真的翻页卷曲效果
// 基于 http://rectalogic.github.com/webvfx/examples_2transition-shader-pagecurl_8html-example.html

// 输入参数
uniform float dividerValue;   // 分割线位置
uniform float curlExtent;     // 卷曲程度
uniform sampler2D source;     // 输入纹理
uniform lowp float qt_Opacity;// 全局不透明度
varying vec2 qt_TexCoord0;    // 纹理坐标

// 常量定义
const float minAmount = -0.16;       // 最小卷曲量
const float maxAmount = 1.3;         // 最大卷曲量
const float PI = 3.141592653589793;  // π值
const float scale = 512.0;           // 缩放因子
const float sharpness = 3.0;         // 边缘锐化程度
const vec4 bgColor = vec4(1.0, 1.0, 0.8, 1.0);  // 背景色（淡黄色）

// 计算当前卷曲量
float amount = curlExtent * (maxAmount - minAmount) + minAmount;
float cylinderCenter = amount;        // 圆柱体中心位置
float cylinderAngle = 2.0 * PI * amount;  // 圆柱体角度（360度 * amount）
const float cylinderRadius = 1.0 / PI / 2.0;  // 圆柱体半径

// 计算卷曲后的命中点
vec3 hitPoint(float hitAngle, float yc, vec3 point, mat3 rrotation)
{
    float hitPoint = hitAngle / (2.0 * PI);
    point.y = hitPoint;
    return rrotation * point;
}

// 抗锯齿处理
vec4 antiAlias(vec4 color1, vec4 color2, float distance)
{
    distance *= scale;
    if (distance < 0.0) return color2;
    if (distance > 2.0) return color1;
    float dd = pow(1.0 - distance / 2.0, sharpness);
    return ((color2 - color1) * dd) + color1;
}

// 计算到边缘的距离
float distanceToEdge(vec3 point)
{
    // 计算点到纹理边缘的最短距离
    float dx = abs(point.x > 0.5 ? 1.0 - point.x : point.x);
    float dy = abs(point.y > 0.5 ? 1.0 - point.y : point.y);
    if (point.x < 0.0) dx = -point.x;
    if (point.x > 1.0) dx = point.x - 1.0;
    if (point.y < 0.0) dy = -point.y;
    if (point.y > 1.0) dy = point.y - 1.0;
    if ((point.x < 0.0 || point.x > 1.0) && (point.y < 0.0 || point.y > 1.0)) 
        return sqrt(dx * dx + dy * dy);
    return min(dx, dy);
}

// 处理透视效果
vec4 seeThrough(float yc, vec2 p, mat3 rotation, mat3 rrotation)
{
    // 计算命中角度
    float hitAngle = PI - (acos(yc / cylinderRadius) - cylinderAngle);
    vec3 point = hitPoint(hitAngle, yc, rotation * vec3(p, 1.0), rrotation);
    // 处理边界情况
    if (yc <= 0.0 && (point.x < 0.0 || point.y < 0.0 || point.x > 1.0 || point.y > 1.0))
        return bgColor;
    if (yc > 0.0)
        return texture2D(source, p);
    vec4 color = texture2D(source, point.xy);
    vec4 tcolor = vec4(0.0);
    return antiAlias(color, tcolor, distanceToEdge(point));
}

// 带阴影的透视效果
vec4 seeThroughWithShadow(float yc, vec2 p, vec3 point, mat3 rotation, mat3 rrotation)
{
    // 计算阴影强度
    float shadow = distanceToEdge(point) * 30.0;
    shadow = (1.0 - shadow) / 3.0;
    if (shadow < 0.0)
        shadow = 0.0;
    else
        shadow *= amount;
    // 应用阴影效果
    vec4 shadowColor = seeThrough(yc, p, rotation, rrotation);
    shadowColor.r -= shadow;
    shadowColor.g -= shadow;
    shadowColor.b -= shadow;
    return shadowColor;
}

// 处理背面效果
vec4 backside(float yc, vec3 point)
{
    vec4 color = texture2D(source, point.xy);
    // 计算灰度值并调整亮度
    float gray = (color.r + color.b + color.g) / 15.0;
    gray += (8.0 / 10.0) * (pow(1.0 - abs(yc / cylinderRadius), 2.0 / 10.0) / 2.0 + (5.0 / 10.0));
    color.rgb = vec3(gray);
    return color;
}

void main(void)
{
    // 设置旋转矩阵
    const float angle = 30.0 * PI / 180.0;  // 30度角
    float c = cos(-angle);
    float s = sin(-angle);
    // 正向旋转矩阵
    mat3 rotation = mat3(
        c, s, 0,
        -s, c, 0,
        0.12, 0.258, 1
    );
    
    // 反向旋转矩阵
    c = cos(angle);
    s = sin(angle);
    mat3 rrotation = mat3(
        c, s, 0,
        -s, c, 0,
        0.15, -0.5, 1
    );
    
    // 计算变换后的点位置
    vec3 point = rotation * vec3(qt_TexCoord0, 1.0);
    float yc = point.y - cylinderCenter;
    vec4 color = vec4(1.0, 0.0, 0.0, 1.0);
    
    // 根据点的位置决定渲染效果
    if (yc < -cylinderRadius) {
        // 显示背景
        color = bgColor;
    } else if (yc > cylinderRadius) {
        // 平面显示
        color = texture2D(source, qt_TexCoord0);
    } else {
        // 卷曲区域的处理
        float hitAngle = (acos(yc / cylinderRadius) + cylinderAngle) - PI;
        float hitAngleMod = mod(hitAngle, 2.0 * PI);
        if ((hitAngleMod > PI && amount < 0.5) || (hitAngleMod > PI/2.0 && amount < 0.0)) {
            // 透视效果
            color = seeThrough(yc, qt_TexCoord0, rotation, rrotation);
        } else {
            // 计算命中点
            point = hitPoint(hitAngle, yc, point, rrotation);
            if (point.x < 0.0 || point.y < 0.0 || point.x > 1.0 || point.y > 1.0) {
                // 边缘处理
                color = seeThroughWithShadow(yc, qt_TexCoord0, point, rotation, rrotation);
            } else {
                // 背面处理
                color = backside(yc, point);
                vec4 otherColor;
                if (yc < 0.0) {
                    // 添加阴影效果
                    float shado = 1.0 - (sqrt(pow(point.x - 0.5, 2.0) + pow(point.y - 0.5, 2.0)) / 0.71);
                    shado *= pow(-yc / cylinderRadius, 3.0);
                    shado *= 0.5;
                    otherColor = vec4(0.0, 0.0, 0.0, shado);
                } else {
                    otherColor = texture2D(source, qt_TexCoord0);
                }
                // 边缘抗锯齿
                color = antiAlias(color, otherColor, cylinderRadius - abs(yc));
            }
        }
    }
    
    // 输出最终颜色
    gl_FragColor = qt_Opacity * color;
}
