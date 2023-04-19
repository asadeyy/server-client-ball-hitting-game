import processing.net.*;
Server server;
Client client;
int port = 12345; 

float x = random(0.0, 600.0) ; // ballx
float y = random(0.0, 400.0); // bally
int s = 5; // ballSize
float v_x = random(1.0, 6.0); // ballSpeed
float v_y = random(1.0, 6.0); // ballSpeed

int py = 200; // サーバー側のマウスのY座標
int px = 50; // サーバー側のマウスのX座標
int playerW = 10; // サーバー側のplayerの幅
int playerH = 50; // サーバー側のplayerの高さ

void setup(){
    //サーバの立ち上げ
    server = new Server(this, port);
    println("サーバー起動");
    size(600,400); 
    background(255);
}

void draw(){
    py = mouseY;
        
    //右側での反射
    if( x + s/2 >= 600) { 
        x = 600 - s/2;
        v_x = v_x * (-1); 
    }
    //左側での反射
    if ( x - s/2 <= 0) {
        x = 0 + s/2;
        v_x = v_x * (-1);
    }
    //上側での反射
    if ( y - s/2 <= 0) {
        y = 0 + s/2;
        v_y = v_y * (-1); 
    }
    //下側での反射
    if ( y + s/2 >= 400) {
        y = 400 - s/2; 
        v_y = v_y * (-1);
    }


    background(255);
    rectMode(CENTER); 
    noStroke();
    fill(0, 0, 0);
    rect(x, y, s, s); 
    x = x + v_x;
    y = y + v_y;

    // サーバー側のplayer
    fill(255, 0, 0);
    rect(px,py,playerW,playerH);

    String msg;
    msg = str(x) + ',' + str(y) + ',' + str(px) + ',' + str(py) + ',' + str(playerW) + ',' + str(playerH) + '\n';
    println(msg);
    server.write(msg);

    // クライアントからの接続
    client = server.available();
    if (client != null) {
        String str = client.readStringUntil('\n');
        if (str != null){
            str = trim(str);
            println("クライアントからのメッセージ: " + str); 
            String[] list = split(str, ','); 
            int client_x = int(list[0]); 
            int client_y = int(list[1]); 
            int client_w = int(list[2]);
            int client_h = int(list[3]);
            rectMode(CENTER);
            noStroke(); 
            fill(255, 0, 0); 
            rect(client_x, client_y, client_w, client_h); 

            // playerに触れたかどうかの判定
            int touch = 0;
            if ((abs(x-client_x)<((s/2)+client_w/2)&&abs(y-client_y)<((s/2)+client_h/2))||(abs(x-px)<((s/2)+playerW/2)&&abs(y-py)<((s/2)+playerH/2))){
                touch = 1;
            }else{
                touch = 0;
            }
            //playerに触れた時の反射
            if(touch == 1){
                v_x = (v_x) * (-1);
                v_y = (v_y) * (-1);
            }
        }
    }else{
        println("クライアントが接続していません");
        background(300,80,99);
        fill(3,1,80);
        textSize(25);
        text("you need to start client job",100,200);
    }
}