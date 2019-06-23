 #!/bin/bash
#随机抽取8位数的密码
X=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
for  i in  {1..8}
do 
    n=$[RANDOM%62]       #求出随机数,范围是0~61之间
    txt=${X:n:1}         #截取出对应的字符
    pass=$pass$txt       #累加放在变量pass里面
done
echo $pass               #循环结束后,得出结果
