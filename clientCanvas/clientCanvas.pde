import processing.net.*;

Client client; 

int port = 12345; 
String server_address = "127.0.0.1"; //他のマシンと通信する場合には"127.0.0.1"を通信したいマシンのIPアドレスに変更する

int py = 200; // マウスのY座標
int px = 550; // マウスのX座標
int playerW = 10; //playerの幅
int playerH = 50; //playerの高さ


void setup() {
  client = new Client(this, server_address, port);
  println("クライアント起動");
  size(600, 400);
  background(255);

}


void draw() {
  py = mouseY;

  if (client.available() > 0) { 
    String str = client.readStringUntil('\n');
    str = trim(str);
    println("サーバからのメッセージ：" + str);
    String[] list = split(str, ','); 
    int server_x = int(list[0]); 
    int server_y = int(list[1]);
    int server_px = int(list[2]);
    int server_py = int(list[3]);
    int server_playerW = int(list[4]);
    int server_playerH = int(list[5]);
    background(255);
    rectMode(CENTER);
    noStroke(); 
    fill(0, 0, 0); 
    rect(server_x, server_y, 5, 5); 
    fill(255, 0, 0);
    rect(px,py,playerW,playerH);
    fill(255, 0, 0);
    rect(server_px,server_py,server_playerW,server_playerH);
    // send data to server
    String msg;
    msg = str(px) + ',' + str(py) + ',' + str(playerW) + ',' + str(playerH) + '\n';
    println(msg);
    client.write(msg); 
  }
}
