#!/usr/bin/env python3
"""记录 sensors 命令输出的温度变化，持续指定时间后输出表格。

用法:
    temp-monitor.py [时长分钟] [采样间隔秒]

示例:
    temp-monitor.py           # 默认10分钟，每2秒采样
    temp-monitor.py 5         # 5分钟
    temp-monitor.py 5 1       # 5分钟，每1秒采样
"""

import subprocess
import re
import sys
import time
from datetime import datetime
from collections import defaultdict

def get_temperatures():
    """运行 sensors 命令并解析温度数据"""
    result = subprocess.run(['sensors'], capture_output=True, text=True)
    temps = {}
    current_adapter = None

    for line in result.stdout.split('\n'):
        line = line.strip()
        # 跳过空行和Adapter行
        if not line or line.startswith('Adapter:'):
            continue
        # 匹配温度行
        temp_match = re.search(r'temp\d+:\s+\+([\d.]+)°C', line)
        if temp_match:
            if current_adapter:
                temps[current_adapter] = float(temp_match.group(1))
        else:
            # 这是适配器名称
            current_adapter = line

    return temps

def main():
    # 解析命令行参数
    duration_minutes = float(sys.argv[1]) if len(sys.argv) > 1 else 10
    interval_seconds = int(sys.argv[2]) if len(sys.argv) > 2 else 2
    total_samples = max(1, int((duration_minutes * 60) // interval_seconds))

    print(f"开始记录温度，持续 {duration_minutes} 分钟，每 {interval_seconds} 秒采样一次...")
    print(f"总计将采集 {total_samples} 次数据\n")

    # 存储所有温度数据
    all_data = defaultdict(list)
    timestamps = []

    start_time = time.time()

    for i in range(total_samples):
        temps = get_temperatures()
        timestamps.append(datetime.now().strftime('%H:%M:%S'))

        for sensor, temp in temps.items():
            all_data[sensor].append(temp)

        # 显示进度
        elapsed = time.time() - start_time
        remaining = duration_minutes * 60 - elapsed
        print(f"\r进度: {i+1}/{total_samples} | 剩余时间: {int(remaining)}秒", end='', flush=True)

        if i < total_samples - 1:
            time.sleep(interval_seconds)

    print("\n\n" + "="*70)
    print("温度变化统计表格")
    print("="*70)

    # 输出统计表格
    # 中文字符占2个显示宽度，需要手动调整
    header = "传感器" + " " * 22 + "最低      最高      平均      变化"
    print(f"\n{header}")
    print("-" * 60)

    for sensor in all_data:
        temps = all_data[sensor]
        min_temp = min(temps)
        max_temp = max(temps)
        avg_temp = sum(temps) / len(temps)
        range_temp = max_temp - min_temp

        # 简化传感器名称显示
        short_name = sensor.replace('_thermal-virtual-0', '')
        print(f"{short_name:<25} {min_temp:>6.1f}°C   {max_temp:>6.1f}°C   {avg_temp:>6.1f}°C   {range_temp:>6.1f}°C")

    print("\n" + "="*80)
    print("详细时间线数据 (每分钟记录)")
    print("="*80)

    # 输出详细数据表格
    sensors = list(all_data.keys())

    # 计算每列宽度
    col_width = 8

    # 表头
    print(f"\n{'时间':<10}", end='')
    for sensor in sensors:
        short_name = sensor.replace('_thermal-virtual-0', '')[:col_width-1]
        print(f"{short_name:>{col_width}}", end='')
    print()
    print("-" * (10 + col_width * len(sensors)))

    # 每60秒输出一次数据
    step = 60 // interval_seconds
    for i in range(0, len(timestamps), step):
        print(f"{timestamps[i]:<10}", end='')
        for sensor in sensors:
            if i < len(all_data[sensor]):
                print(f"{all_data[sensor][i]:>{col_width-2}.1f}°C", end='')
        print()

    # 最后一行（如果不是步长的倍数）
    if timestamps and (len(timestamps) - 1) % step != 0:
        print(f"{timestamps[-1]:<10}", end='')
        for sensor in sensors:
            print(f"{all_data[sensor][-1]:>{col_width-2}.1f}°C", end='')
        print()

    if timestamps:
        print("-" * (10 + col_width * len(sensors)))

if __name__ == '__main__':
    main()
