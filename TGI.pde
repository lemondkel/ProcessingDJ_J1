int speed; // 게임속도
Player player; // 플레이어

PFont defaultFont;//글씨체 기본크기 선택.
PFont secondFont;

int FRAME_TYPE; // 화면 유형 정하기 (현재 화면)
int GAME_INIT = 1; // 게임 초화면
int GAME_INFO = 2; // 게임 안내화면
int GAME_INFO2 = 3; // 게임 안내화면2
int GAME_ING = 4; // 게임 화면
int GAME_RESULT = 5;

int PLAYER_HP = 5; // HP
int TRAP_COUNT = 20; // TRAP COUNT
int TAICHI_COUNT = 5; // TAICHI COUNT
int STAGE_COUNT = 1; // STAGE 1 (DEFAULT)
int SCORE = 0; // GAME SCORE

// Jump
float px = 0;
float py = 700;
float vx = 0;
float vy = 0;
float ax = 0;
float ay = 0;
int jumpCount = 0; // 점프횟수
boolean escape = false;

boolean[] keys = { false, false };
Trap[] trapList;
Taichi[] taichiList;

void setup() {
  size(1280, 1024);
  defaultFont = createFont("굴림", 84);
  secondFont = createFont("궁서", 72);
  textAlign(CORNER);//텍스트 위치 잡기.

  initView(GAME_INIT); // 화면 초기화
}

void draw() {
  if (FRAME_TYPE == GAME_INIT) {
    // 화면 유형이 초기화면인 경우
    if ((mouseX >= 380 && mouseY >=730) && (mouseX <= 860 && mouseY <= 810)) {//마우스가 범위 이내에 들어오면
      textSize(72);
      fill(255, 255, 255);//글씨가 흰색으로 변함.
      textFont(secondFont);
      textAlign(CORNER);
      text("GAME START", 400, 800);
    } else {
      textSize(72);
      fill(0, 0, 0);// 마우스가 범위 이내가 아니라면 글씨가 검은색으로 있음.
      textFont(secondFont);
      textAlign(CORNER);
      text("GAME START", 400, 800);
    }
  } else if (FRAME_TYPE == GAME_ING) {
    // 게임중의 경우
    if (PLAYER_HP <= 0) {
      initView(GAME_INIT);
    } else {
      simulate();
      initView(GAME_ING);
    }
  }
}

void keyPressed() {
  if (FRAME_TYPE == GAME_ING) {
    if ( keyCode == LEFT ) {
      keys[0] = true;
    }
    if ( keyCode == RIGHT ) {
      keys[1] = true;
    }
    if (jumpCount < 2) {
      if ( key == ' ' ) {
        vy = -12;
      }
    }
  }
}

void keyReleased() {
  if ( keyCode == LEFT ) {
    keys[0] = false;
  }
  if ( keyCode == RIGHT ) {
    keys[1] = false;
  }
  if ( key == ' ' ) {
    if (FRAME_TYPE == GAME_INIT) {
      // 화면 유형이 초기화면인 경우
      initView(GAME_INFO); // 설명 화면으로  초기화
    } else if (FRAME_TYPE == GAME_INFO) {
      // 화면 유형이 초기화면인 경우
      initView(GAME_INFO2); // 2번째 설명 화면으로 초기화
    } else if (FRAME_TYPE == GAME_INFO2) {
      // 화면 유형이 게임 방법 화면인 경우
      if (trapList == null) {
        trapList = new Trap[TRAP_COUNT];
      }
      int[] randomPosArr = new int[TRAP_COUNT];
      for (int i=0; i<TRAP_COUNT; i++) {
        randomPosArr[i] = 1280 + (i * ((int)(Math.random() * 200) + 100));

        int imageType = (int)(Math.random() * 3);
        String imageURL = ""; // Image URL
        switch (imageType) {
        case 0:
          imageURL = "uniqlo.PNG";
          break;
        case 1:
          imageURL = "abcM.PNG";
          break;
        case 2:
          imageURL = "decente.PNG";
          break;
        }
        if (trapList[i] == null) {
          trapList[i] = new Trap(imageURL, randomPosArr[i], 800);
        }
        image(trapList[i].getImage(), trapList[i].getX(), trapList[i].getY(), 110, 110);
      }


      if (taichiList == null) {
        taichiList = new Taichi[TAICHI_COUNT];
      }
      randomPosArr = new int[TAICHI_COUNT];
      for (int i=0; i<TAICHI_COUNT; i++) {
        randomPosArr[i] = 1280 + (i * ((int)(Math.random() *  trapList[TRAP_COUNT - 1].getX())));

        int imageType = (int)(Math.random() * 2);
        int type = 0;
        String imageURL = ""; // Image URL
        switch (imageType) {
        case 0:
          imageURL = "taichi.PNG";
          type = 0;
          break;
        case 1:
          imageURL = "shiny_taichi.PNG";
          type = 1;
          break;
        }
        if (taichiList[i] == null) {
          taichiList[i] = new Taichi(imageURL, randomPosArr[i], 800, type);
        }
        image(taichiList[i].getImage(), taichiList[i].getX(), taichiList[i].getY(), 110, 110);
      }

      initView(GAME_ING); // 게임 화면으로 이동
    } else if (FRAME_TYPE == GAME_ING) {
      jumpCount++;
    } else if (FRAME_TYPE == GAME_RESULT) {
      STAGE_COUNT++;
      TRAP_COUNT = TRAP_COUNT + 2;
      if (TAICHI_COUNT > 2) {
        TAICHI_COUNT--;
      }
      speed += 2;
      px = 0;
      py = 700;
      trapList = null;
      taichiList = null;

      // 화면 유형이 게임 방법 화면인 경우
      if (trapList == null) {
        trapList = new Trap[TRAP_COUNT];
      }
      int[] randomPosArr = new int[TRAP_COUNT];
      for (int i=0; i<TRAP_COUNT; i++) {
        randomPosArr[i] = 1280 + (i * ((int)(Math.random() * 200) + 100));

        int imageType = (int)(Math.random() * 3);
        String imageURL = ""; // Image URL
        switch (imageType) {
        case 0:
          imageURL = "uniqlo.PNG";
          break;
        case 1:
          imageURL = "abcM.PNG";
          break;
        case 2:
          imageURL = "decente.PNG";
          break;
        }
        if (trapList[i] == null) {
          trapList[i] = new Trap(imageURL, randomPosArr[i], 800);
        }
        image(trapList[i].getImage(), trapList[i].getX(), trapList[i].getY(), 110, 110);
      }

      if (taichiList == null) {
        taichiList = new Taichi[TAICHI_COUNT];
      }
      randomPosArr = new int[TAICHI_COUNT];
      for (int i=0; i<TAICHI_COUNT; i++) {
        randomPosArr[i] = 1280 + (i * ((int)(Math.random() * 200) + 100));

        int imageType = (int)(Math.random() * 2);
        int type = 0;
        String imageURL = ""; // Image URL
        switch (imageType) {
        case 0:
          imageURL = "taichi.PNG";
          type = 0;
          break;
        case 1:
          imageURL = "shiny_taichi.PNG";
          type = 1;
          break;
        }
        if (taichiList[i] == null) {
          taichiList[i] = new Taichi(imageURL, randomPosArr[i], 800, type);
        }
        image(taichiList[i].getImage(), taichiList[i].getX(), taichiList[i].getY(), 110, 110);
      }
      initView(GAME_ING);
    }
  }
}

void mousePressed() {
  if (FRAME_TYPE == GAME_INIT) {
    // 화면 유형이 초기화면인 경우
    if ((mouseX >= 380 && mouseY >=730) && (mouseX <= 860 && mouseY <= 810)) { 
      initView(GAME_INFO); // 설명 화면으로  초기화
    }
  } else if (FRAME_TYPE == GAME_INFO) {
    // 화면 유형이 초기화면인 경우
    if ((mouseX >= 960 && mouseY >=840) && (mouseX <= 960+150 && mouseY <= 840+60)) { 
      initView(GAME_INFO2); // 2번째 설명 화면으로 초기화
    }
  } else if (FRAME_TYPE == GAME_INFO2) {
    // 화면 유형이 게임 방법 화면인 경우
    if ((mouseX >= 960 && mouseY >=840) && (mouseX <= 960+150 && mouseY <= 840+60)) {
      trapList = new Trap[TRAP_COUNT];
      int[] randomPosArr = new int[TRAP_COUNT];
      for (int i=0; i<TRAP_COUNT; i++) {
        randomPosArr[i] = 1280 + (i * ((int)(Math.random() * 200) + 100));

        int imageType = (int)(Math.random() * 3);
        String imageURL = ""; // Image URL
        switch (imageType) {
        case 0:
          imageURL = "uniqlo.PNG";
          break;
        case 1:
          imageURL = "abcM.PNG";
          break;
        case 2:
          imageURL = "decente.PNG";
          break;
        }
        trapList[i] = new Trap(imageURL, randomPosArr[i], 800);
        image(trapList[i].getImage(), trapList[i].getX(), trapList[i].getY(), 110, 110);
      }

      taichiList = new Taichi[TAICHI_COUNT];
      randomPosArr = new int[TAICHI_COUNT];
      for (int i=0; i<TAICHI_COUNT; i++) {
        randomPosArr[i] = 1280 + (i * ((int)(Math.random() * 200) + 100));

        int imageType = (int)(Math.random() * 3);
        int type = 0;
        String imageURL = ""; // Image URL
        switch (imageType) {
        case 0:
          imageURL = "uniqlo.PNG";
          type = 0;
          break;
        case 1:
          imageURL = "abcM.PNG";
          type = 1;
          break;
        }
        taichiList[i] = new Taichi(imageURL, randomPosArr[i], 800, type);
        image(taichiList[i].getImage(), taichiList[i].getX(), taichiList[i].getY(), 110, 110);
      }

      initView(GAME_ING); // 게임 화면으로 이동
    }
  } else if (FRAME_TYPE == GAME_RESULT) {
    // 화면 유형이 결과화면인 경우
    if ((mouseX >= 960 && mouseY >=840) && (mouseX <= 960+150 && mouseY <= 840+60)) { 
      trapList = new Trap[TRAP_COUNT];
      int[] randomPosArr = new int[TRAP_COUNT];
      for (int i=0; i<TRAP_COUNT; i++) {
        randomPosArr[i] = 1280 + (i * ((int)(Math.random() * 200) + 100));

        int imageType = (int)(Math.random() * 3);
        String imageURL = ""; // Image URL
        switch (imageType) {
        case 0:
          imageURL = "uniqlo.PNG";
          break;
        case 1:
          imageURL = "abcM.PNG";
          break;
        case 2:
          imageURL = "decente.PNG";
          break;
        }
        trapList[i] = new Trap(imageURL, randomPosArr[i], 800);
        image(trapList[i].getImage(), trapList[i].getX(), trapList[i].getY(), 110, 110);
      }

      taichiList = new Taichi[TAICHI_COUNT];
      randomPosArr = new int[TAICHI_COUNT];
      for (int i=0; i<TAICHI_COUNT; i++) {
        randomPosArr[i] = 1280 + (i * ((int)(Math.random() * 200) + 100));

        int imageType = (int)(Math.random() * 3);
        int type = 0;
        String imageURL = ""; // Image URL
        switch (imageType) {
        case 0:
          imageURL = "uniqlo.PNG";
          type = 0;
          break;
        case 1:
          imageURL = "abcM.PNG";
          type = 1;
          break;
        }
        taichiList[i] = new Taichi(imageURL, randomPosArr[i], 800, type);
        image(taichiList[i].getImage(), taichiList[i].getX(), taichiList[i].getY(), 110, 110);
      }

      initView(GAME_ING); // 다음스테이지 화면으로 이동
    }
  }
}

// 트랩
class Trap {
  PImage image;
  int x;
  int y;
  boolean deleted;
  Trap (String url, int x, int y) {
    this.image = loadImage(url);
    this.x = x;
    this.y = y;
    this.deleted = false;
  }

  PImage getImage() {
    return this.image;
  }

  boolean isDeleted() {
    return this.deleted;
  }

  void destroy() {
    this.deleted = true;
  }

  void setX (int x) {
    this.x = x;
  }

  void setY (int y) {
    this.y = y;
  }

  int getX () {
    return this.x;
  }

  int getY () {
    return this.y;
  }
}

// 트랩
class Taichi {
  PImage image;
  int x;
  int y;
  int type;
  boolean deleted;
  Taichi (String url, int x, int y, int type) {
    this.image = loadImage(url);
    this.x = x;
    this.y = y;
    this.deleted = false;
    this.type = type;
  }

  int getType() {
    return this.type;
  }

  PImage getImage() {
    return this.image;
  }

  boolean isDeleted() {
    return this.deleted;
  }

  void destroy() {
    this.deleted = true;
  }

  void setX (int x) {
    this.x = x;
  }

  void setY (int y) {
    this.y = y;
  }

  int getX () {
    return this.x;
  }

  int getY () {
    return this.y;
  }
}

class Player {
  PImage img; // 플레이어 생긴모습 URL
  int x; // 현재 위치 x
  int y; // 현재 위치 y

  // 플레이어 생성시
  Player (String url, int x, int y) {
    this.img = loadImage(url);
    this.x = x;
    this.y = y;
  }
}

// 화면 초기화할 때 사용하는 함수
void initView(int viewType) {
  if (viewType == GAME_INIT) {//초기 시작화면이라면
    FRAME_TYPE = GAME_INIT;
    //fill(163, 255, 150);
    //rect(0, 0, 1280, 1024);
    PImage Start_View = loadImage("Start_View.jpg");//초기 시작 배경
    //PImage player_icon = loadImage("player.PNG");
    //player_icon.resize(0, 350);
    image(Start_View, 0, 0, width, height);

    // init HP
    PLAYER_HP = 5;
    STAGE_COUNT = 1;
    SCORE = 0;
    px = 0;
    py = 700;
    speed = 5;
    trapList = null;

    fill(0, 0, 255);
    textFont(defaultFont);
    textSize(100);
    textAlign(CENTER);//텍스트 적는 위치 중앙.
    text("태극이를 도와줘!", width/2, height/4);

    //    textSize(72);
    //    fill(0, 0, 0);
    //    textFont(secondFont);
    //    text("GAME START", 400, 800);
  } else if (viewType == GAME_INFO) {//설명1 화면이라면
    // 안내 화면
    FRAME_TYPE = GAME_INFO;
    fill(54, 88, 120);
    rect(0, 0, 1280, 1024);
    //fill(255, 201, 180);
    //rect(60, 250, width-130, height-310);
    PImage INFO_View = loadImage("Testimg.jpg");
    tint(240);//투명도 조절.
    image(INFO_View, 60, 250, width-125, height-310);

    textSize(84);
    fill(0, 0, 0);
    textFont(defaultFont);
    text("[게임 방법]", 400, 190);

    fill(255, 255, 255, 50);    
    rect(960, 840, 150, 60);
    textSize(36);
    fill(0, 0, 0);
    text("다음>>", 980, 880);

    fill(0, 0, 0);
    textFont(defaultFont);
    textSize(36);//게임 방식 글로 설명.
    text("* 스페이스(Space Bar)를 누르면 점프를 할 수 있습니다. \n* 점프는 2단까지 가능합니다. \n* 태극이는 한 방향으로 계속 직진합니다."+
      "\n* 태극이를 도와 함정을 피해 태극마크를 획득하세요!", 100, 330);
    textSize(30);
    text("  - 태극마크:+50점, 함정:-50점 \n  - 빛나는 태극마크를 획득하면 20초간 모든 점수가 5배가 됩니다."+
      "\n  - 태극마크를 획득하면 속도가 빨라지고 함정이 발동되면 속도가 느려집니다. \n  - 함정이 5번 발동되면 체력이 0이 되어 게임이 종료됩니다.", 100, 520);
    textSize(36);
    text("\n* 제한시간 동안 특정 조건을 완료하면 다음 스테이지로 갑니다.\n* 스테이지가 상승하면 초기속도가 빨라집니다.\n* 모든 아이템의 획득 점수가 10 상승합니다."+
      "\n* 모든 함정의 점수가 10 감소합니다.", 100, 660);
  } else if (viewType == GAME_INFO2) {//설명 2 화면이라면
    // 안내 화면
    FRAME_TYPE = GAME_INFO2;
    fill(54, 88, 120);
    rect(0, 0, 1280, 1024);
    //fill(255, 201, 180);
    //rect(60, 250, width-130, height-310);
    PImage INFO_View = loadImage("Testimg.jpg");
    tint(240);
    image(INFO_View, 60, 250, width-125, height-310);

    textSize(84);
    fill(0, 0, 0);
    textFont(defaultFont);
    text("[게임 방법]", 400, 190);

    fill(255, 255, 255, 50);    
    rect(960, 840, 150, 60);
    textSize(36);
    fill(0, 0, 0);
    text("Start>>", 980, 880);



    fill(0, 0, 0);
    textFont(defaultFont);
    textSize(28);
    text("* 초기 기본설정 점수 배점입니다.", 100, 330);

    PImage Item1 = loadImage("taichi.PNG");// 아이템 그림 및 설명.
    image(Item1, 170, 390, 120, 120);
    text("- 태극마크 +50점\n- 속도증가", 330, 430);

    PImage Item2 = loadImage("shiny_taichi.PNG");
    image(Item2, 160, 620, 140, 140);
    text("- 빛나는 태극마크\n- 20초동안 모든점수 5배\n- 속도증가", 330, 660);

    PImage Item3 = loadImage("uniqlo.PNG");
    image(Item3, 680, 390, 110, 110);
    text("- 함정1 -50점\n- 속도감소\n- HP감소", 820, 420);

    PImage Item4 = loadImage("abcM.PNG");
    image(Item4, 680, 550, 110, 110);
    text("- 함정2 -50점\n- 속도감소\n- HP감소", 820, 570);

    PImage Item5 = loadImage("decente.PNG");
    image(Item5, 680, 700, 110, 110);
    text("- 함정3 -50점\n- 속도감소\n- HP감소", 820, 730);


    //[수정필요사항]
    //설명 정돈. 좋은 생각을 하고싶다.
    //생각하니까 HP이야기 해서 함정 5개 발생시 죽는걸로 해놓고 체력을 안 고려했네요 ...ㅜㅜ헝
    // 스테이지별로 500점 획득시 다음 스테이지. 함정 갯수를 점점 늘려봐요.
  } else if (viewType == GAME_ING) {
    // 게임중인 화면
    FRAME_TYPE = GAME_ING;
    fill(163, 255, 150);
    rect(0, 0, 1280, 900);
    fill(102, 60, 17);
    rect(0, 900, 1280, 124);
    textFont(defaultFont);
    textSize(28);
    text("[" + STAGE_COUNT + " STAGE]", 100, 50);
    text("PLAYER HP: " + PLAYER_HP, 100, 100);
    text("SCORE: " + SCORE, 100, 150);
    player = new Player("player.PNG", 10, 10);
    image(player.img, px-10, py-20, 300, 300);

    int deletedCount = 0;
    for (int i=0; i<TRAP_COUNT; i++) {
      if (trapList[i].isDeleted() == false) {
        image(trapList[i].getImage(), trapList[i].getX() - 2, 800, 110, 110);
        if (trapList[i].getX() <= 0) {
          trapList[i].destroy();
        } else {
          trapList[i].setX(trapList[i].getX() - speed);
        }
      } else {
        deletedCount++;
      }
    }

    int deletedCount2 = 0;
    for (int i=0; i<TAICHI_COUNT; i++) {
      if (taichiList[i].isDeleted() == false) {
        image(taichiList[i].getImage(), taichiList[i].getX() - 2, 800, 110, 110);
        if (taichiList[i].getX() <= 0) {
          taichiList[i].destroy();
        } else {
          taichiList[i].setX(taichiList[i].getX() - speed);
        }
      } else {
        deletedCount2++;
      }
    }

    if (deletedCount == TRAP_COUNT && deletedCount2 == TAICHI_COUNT ) {
      initView(GAME_RESULT);
    }
  } else if (viewType == GAME_RESULT) {//설명1 화면이라면
    // 안내 화면
    FRAME_TYPE = GAME_RESULT;
    fill(54, 88, 120);
    rect(0, 0, 1280, 1024);
    //fill(255, 201, 180);
    //rect(60, 250, width-130, height-310);
    PImage INFO_View = loadImage("Testimg.jpg");
    tint(240);//투명도 조절.
    image(INFO_View, 60, 250, width-125, height-310);

    textSize(84);
    fill(0, 0, 0);
    textFont(defaultFont);
    text("[스테이지 " + STAGE_COUNT + " 끝]", 400, 190);

    fill(255, 255, 255, 50);    
    rect(960, 840, 150, 60);
    textSize(36);
    fill(0, 0, 0);
    text("다음>>", 980, 880);

    fill(0, 0, 0);
    textFont(defaultFont);
    textSize(72);//게임 방식 글로 설명.
    text("Score: " + SCORE, 100, 330);
    text("HP: " + PLAYER_HP, 100, 430);
  }
}


void simulate() {
  ax = 0;
  ax += keys[0]?-4.0:0;
  ax += keys[1]?4.0:0;
  ay = .28;
  vx=ax;
  vy+=ay;
  px+=vx;
  py+=vy;
  if ( px<10) {
    vx = 0;
    ax = 0;
    px = 10;
  }
  if ( px>1280) {
    //오른쪽 끝자락 도달한 경우
    vx = 0;
    ax = 0;
    px = 10;
    // 스테이지 끝난 경우!
  }

  if (py>700) { 
    py=700; 
    vy=0;
    ay=0;
    jumpCount = 0;
  }

  for (int i=0; i<trapList.length; i++) {
    if (trapList[i].isDeleted() == false) {
      if ((px - trapList[i].getX() < 50 && px - trapList[i].getX() > -200)
        && (py - trapList[i].getY() < 200 && py - trapList[i].getY() > -200)) {
        SCORE = SCORE - 50;
        PLAYER_HP--;
        trapList[i].destroy();
      }
    }
  }

  for (int i=0; i<taichiList.length; i++) {
    if (taichiList[i].isDeleted() == false) {
      if ((px - taichiList[i].getX() < 50 && px - taichiList[i].getX() > -200)
        && (py - taichiList[i].getY() < 200 && py - taichiList[i].getY() > -200)) {
        if (taichiList[i].getType() == 0) {
          SCORE = SCORE +50;
        } else if (taichiList[i].getType() == 1) {
          SCORE = SCORE +250;
        }
        taichiList[i].destroy();
      }
    }
  }
}
