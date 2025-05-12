//VARIABLE DECLARATIONS
 //Grid
int gridSize = 40;
int gridWidth = 800;
int gridHeight = 800;
int gridWMargin = 20;
int gridHMargin = 60;
int gridRows = (gridHeight - gridHMargin) / gridSize;
int gridColumns = (gridWidth - gridWMargin) / gridSize;
int[][] grid;
 //Screen
int rectWidth = gridWidth*2/3;
int rectHeight = gridHeight*1/2;
int rectX = (gridWidth-rectWidth)/2;
int rectY = (gridHeight-rectHeight)/2;
 //Snake
int snakeLength = 1;
int[] snakeX, snakeY;
 //Apple
int appleX, appleY;
 //Movements
int direction = 0;
int score = 0;
 //Game booleans
boolean gameOver = false;
boolean gameStarted = false;
boolean gameCompleted = false;

void setup() {
//SETTING UP THE CANVAS
  size(800, 800); //Canvas Size
  smooth(); //Makes Game smooth
  frameRate(5); //FrameRate is set to 5
  setGame(); // Setting up the game
}

void draw() {
//DISPLAYING SCREENS  
  //Display Welcome screen
  if (!gameStarted) {
    background(0, 150, 0); 
    drawGrid();
    strokeWeight(1);
    welcomeScreen();
    return;
  }
  //Display Game over screen
  if (gameOver) {
    gameOverScreen();
    return;
  }
  //Display Game won screen
  if (gameCompleted) {
    wonScreen();
    return;
  }
  
  //Calling the function reponsible for running the game
  background(0, 150, 0);
  drawGrid();
  drawSnake();
  drawapple(appleX, appleY);
  moveSnake();
  checkCollisions();
  checkappleEaten();
  displayScore();
}

void displayScore() {
//DISPLAYING THE SCORE ON THE ROP RIGHT OF THE CANVAS
  textAlign(RIGHT, TOP);
  textSize(20);
  fill(255);
  text("Score: " + score, width - 20, 20);
}

void welcomeScreen() {
//THE WELCOME SCREEN MODEL
  noStroke();
  fill(50, 250, 250);
  rect(rectX, rectY, rectWidth, rectHeight);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(40);
  text("WELCOME TO SNAKE GAME", width / 2, (height / 2) - (gridHeight/8));
  textSize(20);
  text("=====================================================", width / 2, (height / 2) - (gridHeight/20));
  text("=====================================================", width / 2, (height / 2) + (gridHeight/20));
  text("Press SHIFT KEY to start", width / 2, (height / 2) + (gridHeight/10));
  textSize(15);
  text("Use the ARROW KEYS to CONTROL the snake", width / 2, (height / 2) - (gridHeight/30));
  text("EAT 10 APPLES to WIN the game", width / 2, (height / 2) - (gridHeight/250));
  text("If you COLLIDE with the BOUNDARIES or your OWN BODY, the GAME is OVER", width / 2, (height / 2) + (gridHeight/40));  
}

void gameOverScreen() {
//THE GAME OVER SCREEN MODEL
  fill(250, 50, 50);
  rect(rectX, rectY, rectWidth, rectHeight);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(40);
  text("GAME OVER", width / 2, (height / 2) - (gridHeight/16));
  textSize(20);
  text("YOU HAVE COLLIDED!!!", width / 2, (height / 2) + (gridHeight/160));
  text("Press SHIFT to PLAY AGAIN", width / 2, (height / 2) + (gridHeight/16));
}

void wonScreen() {
//THE WON SCREEN MODEL
  fill(50, 250, 50);
  rect(rectX, rectY, rectWidth, rectHeight);
  textAlign(CENTER, CENTER);
  fill(0);
  textSize(40);
  text("YOU HAVE WON THE GAME!!!", width / 2, (height / 2) - (gridHeight/40));
  textSize(20);
  text("Press SHIFT to RESTART", width / 2, (height / 2) + (gridHeight/40));
}

void resetGame() {
//RESETTING THE GAME
  gameStarted = true;
  setGame(); //
  return;
}

void setGame() {
//SETTING UP THE GAME
  //Grid Data
  grid = new int[gridRows][gridColumns];
  //Snake Data
  snakeX = new int[gridRows * gridColumns];
  snakeY = new int[gridRows * gridColumns];
  snakeLength = 1;
  //Initial Score
  score = 0;
  //Booleans involved
  gameOver = false;
  gameCompleted = false;
  //Position of the snake
  snakeX[0] = gridColumns / 2;
  snakeY[0] = gridRows / 2;
  //Calling function to generate apple
  generateapple();
}

void generateapple() {
//GENERATING APPLE IN RANDOM POSITIONS
  appleX = int(random(gridColumns));
  appleY = int(random(gridRows));
}

void drawGrid() {
//DRAWING GRID
  for (int i = 0; i < gridRows; i++) {
    for (int j = 0; j < gridColumns; j++) {
      int x = gridWMargin + (j * gridSize);
      int y = gridHMargin + (i * gridSize);
      boolean colour = (i + j) % 2 == 0;
      //Calling Drawcell function
      drawCell(x, y, colour);
    }
  }
}

void drawCell(float x, float y, boolean colour) {
//DRAWING CELLS OF THE GRID
  strokeWeight(0);
  if (colour) {
    fill(50, 250, 100);
  } else {
    fill(240, 245, 235);
  }
  rect(x, y, gridSize, gridSize);
}

void drawSnake() {
//DRAWING SNAKE
  for (int i = 0; i < snakeLength; i++) {
    int x = gridWMargin + snakeX[i] * gridSize + gridSize / 2;
    int y = gridHMargin + snakeY[i] * gridSize + gridSize / 2;
    fill(255, 255, 150); //Colour
    if (i == 0) {
      stroke(0);
      strokeWeight(1);
      ellipse(x, y, gridSize*7/5, gridSize*7/5); //Head of the snake
      //For up direction
      if (direction==0) {
        fill(255); //Eye colour of the snake
        ellipse(x-gridSize/5, y+gridSize/4, gridSize/3, gridSize/3); //Eyes of the snake
        ellipse(x+gridSize/5, y+gridSize/4, gridSize/3, gridSize/3); //Eyes of the snake
        fill(0); //Eye ball colour of the snake
        ellipse(x-gridSize/5, y+gridSize/6, gridSize/6, gridSize/6); //Eye ball of the snake
        ellipse(x+gridSize/5, y+gridSize/6, gridSize/6, gridSize/6); //Eye ball of the snake
        strokeWeight(1);
        noFill();
        ellipse(x-gridSize/10, y-gridSize/5, gridSize/7, gridSize/7); //Nose of the snake
        ellipse(x+gridSize/10, y-gridSize/5, gridSize/7, gridSize/7); //Nose of the snake
        stroke(255, 0, 0); //Tongue colour of the snake
        strokeWeight(3);
        line(x, y-gridSize/2.5, x, y-gridSize*7/8); //Tongue of the snake
        //For right direction
      } else if (direction==1) {
        fill(255);
        ellipse(x-gridSize/4, y-gridSize/5, gridSize/3, gridSize/3);
        ellipse(x-gridSize/4, y+gridSize/5, gridSize/3, gridSize/3);
        fill(0);
        ellipse(x-gridSize/6, y-gridSize/5, gridSize/6, gridSize/6);
        ellipse(x-gridSize/6, y+gridSize/5, gridSize/6, gridSize/6);
        strokeWeight(1);
        noFill();
        ellipse(x+gridSize/5, y+gridSize/10, gridSize/7, gridSize/7);
        ellipse(x+gridSize/5, y-gridSize/10, gridSize/7, gridSize/7);
        stroke(255, 0, 0);
        strokeWeight(3);
        line(x+gridSize/2.5, y, x+gridSize*7/8, y);
        //For down direction
      } else if (direction==2) {
        fill(255);
        ellipse(x-gridSize/5, y-gridSize/4, gridSize/3, gridSize/3);
        ellipse(x+gridSize/5, y-gridSize/4, gridSize/3, gridSize/3);
        fill(0);
        ellipse(x-gridSize/5, y-gridSize/6, gridSize/6, gridSize/6);
        ellipse(x+gridSize/5, y-gridSize/6, gridSize/6, gridSize/6);
        strokeWeight(1);
        noFill();
        ellipse(x-gridSize/10, y+gridSize/5, gridSize/7, gridSize/7);
        ellipse(x+gridSize/10, y+gridSize/5, gridSize/7, gridSize/7);
        stroke(255, 0, 0);
        strokeWeight(3);
        line(x, y+gridSize/2.5, x, y+gridSize*7/8);
        //For left direction
      } else if (direction==3) {
        fill(255);
        ellipse(x+gridSize/4, y-gridSize/5, gridSize/3, gridSize/3);
        ellipse(x+gridSize/4, y+gridSize/5, gridSize/3, gridSize/3);
        fill(0);
        ellipse(x+gridSize/6, y-gridSize/5, gridSize/6, gridSize/6);
        ellipse(x+gridSize/6, y+gridSize/5, gridSize/6, gridSize/6);
        strokeWeight(1);
        noFill();
        ellipse(x-gridSize/5, y+gridSize/10, gridSize/7, gridSize/7);
        ellipse(x-gridSize/5, y-gridSize/10, gridSize/7, gridSize/7);
        stroke(255, 0, 0);
        strokeWeight(3);
        line(x-gridSize/2.5, y, x-gridSize*7/8, y);
      }
      stroke(0);
      strokeWeight(1);
    } else {
      //New bodies of the snake
      rect(x - gridSize / 2, y - gridSize / 2, gridSize, gridSize, 50, 50, 50, 50);
    }
  }
}

void drawapple(float x, float y) {
//DRAWING APPLE
  fill(250, 50, 0); //Apple colour
  float appleX = gridWMargin + x * gridSize + gridSize / 2;
  float appleY = gridHMargin + y * gridSize + gridSize / 2;
  //apple
  ellipse(appleX, appleY, gridSize, gridSize);
  strokeWeight(3);
  stroke(0);
  line(appleX, appleY-10, appleX, appleY-30);
  noStroke();
}

void moveSnake() {
//MOVING SNAKE
  //New head declaration
  int newHeadX = snakeX[0];
  int newHeadY = snakeY[0];
  //Motion of the snake
  if (direction == 0) {
    newHeadY--;
  } else if (direction == 1) {
    newHeadX++;
  } else if (direction == 2) {
    newHeadY++;
  } else if (direction == 3) {
    newHeadX--;
  }
  //New head position
  for (int i = snakeLength + 1; i > 0; i--) {
    snakeX[i] = snakeX[i - 1];
    snakeY[i] = snakeY[i - 1];
  }
  //New head
  snakeX[0] = newHeadX;
  snakeY[0] = newHeadY;
}

void checkCollisions() {
//CHECKING COLLISION AND ENDING IF COLLIDED
  //Checking boundary collision
  if (snakeX[0] < 0 || snakeX[0] >= gridColumns || snakeY[0] < 0 || snakeY[0] >= gridRows) {
    gameOver = true;
    return;
  }
  //Checking self collision
  for (int i = 1; i < snakeLength; i++) {
    if (snakeX[0] == snakeX[i] && snakeY[0] == snakeY[i]) {
      gameOver = true;
      return;
    }
  }
}

void checkappleEaten() {
//CHECKING APPLES EATED
  //Collison of head and apple (=apples eaten)
  if (snakeX[0] == appleX && snakeY[0] == appleY) {
    score++; //Increasing the score
    snakeLength++; //Adding new body (increasing the length)
    generateapple(); //Again generating new apple
  }
  //Condition for game is won
  if (score>=10) {
    gameCompleted = true;
    return;
  }
}

void keyPressed() {
//CONTROLLING SNAKE USING KEY
  //Declaring SHIFT key for Initializing or resetting the game
  if (keyCode == SHIFT) {
    if (gameOver) {
      resetGame();
    } else if (gameCompleted) {
      resetGame();
    } else {
      gameStarted = true;
    }
  //Controlling keys of snake
  } else if (gameStarted) {
    //Snake should not move in the opposite direction if length is more than 1
    if(snakeLength >= 2) {
      if (keyCode == UP && direction != 2) {
        direction = 0;
      } else if (keyCode == DOWN && direction != 0) {
        direction = 2;
      } else if (keyCode == RIGHT && direction != 3) {
        direction = 1;
      } else if (keyCode == LEFT && direction != 1) {
        direction = 3;
      }
    }
    //Snake can move in any direction if length is 1
    else {
      if (keyCode == UP) {
        direction = 0;
      } else if (keyCode == DOWN) {
        direction = 2;
      } else if (keyCode == RIGHT) {
        direction = 1;
      } else if (keyCode == LEFT) {
        direction = 3;
      }
    }
  }
}
