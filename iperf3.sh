#!/bin/bash

echo "欢迎使用 iPerf3 测试脚本！"

# 获取监听端或客户端选择
echo "请选择模式（1: 监听端, 2: 客户端）："
read -p "请输入选择：" MODE

if [ "$MODE" == "1" ]; then
  # 监听端模式
  echo "启动 iPerf3 监听端..."
  iperf3 -s
elif [ "$MODE" == "2" ]; then
  # 客户端模式
  read -p "请输入监听端地址：" SERVER
  echo "请选择协议（1: tcp, 2: udp）："
  read -p "请输入选择（默认1）：" PROTOCOL_CHOICE
  PROTOCOL_CHOICE=${PROTOCOL_CHOICE:-1}

  if [ "$PROTOCOL_CHOICE" == "2" ]; then
    PROTOCOL="udp"
  else
    PROTOCOL="tcp"
  fi

  read -p "请输入测试时间（默认10秒）：" TIME
  TIME=${TIME:-10}

  # 设置默认端口
  PORT=5201

  # 获取其他选项
  read -p "是否使用多线程？(y/n，默认y)：" MULTITHREAD
  MULTITHREAD=${MULTITHREAD:-y}
  if [ "$MULTITHREAD" == "y" ]; then
    read -p "请输入并行线程数（默认10）：" THREADS
    THREADS=${THREADS:-10}
  else
    THREADS=1
  fi

  if [ "$PROTOCOL" == "udp" ]; then
    read -p "请输入带宽（例如 5M, 100K）：" BANDWIDTH
    COMMAND="iperf3 -u -c $SERVER -b $BANDWIDTH -P $THREADS -t $TIME"
  else
    COMMAND="iperf3 -c $SERVER -P $THREADS -t $TIME"
  fi

  echo "即将执行命令：$COMMAND"
  $COMMAND
else
  echo "无效选择，请重新运行脚本并选择有效模式。"
fi
