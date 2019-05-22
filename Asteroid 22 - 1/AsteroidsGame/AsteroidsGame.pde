//the player which the user (you) controls
//Jogador humano que controla
Player humanPlayer;
//A populacao
Population pop; 
//Taxa de velocidade / framerate
int speed = 100;
//Taxa de mutacao
float globalMutationRate = 10;
//Configurando a fonte
PFont font;
//boolean Values 
//true if only show the best of the previous generation
//true se mostrar apenas o melhor da geração anterior
//Se colocar false ele mostra todos em funcionamento
boolean showBest = true;
//true if replaying the best ever game
//true se repetir o melhor jogo de sempre
boolean runBest = false; 
//true if the user is playing
//Se for true o jogador vai ser o usuario
boolean humanPlaying = false;

//Iniciando o game
void setup() {
  //Tamanho da tela em px
  size(1200, 675);
  //Criando o jogador
  humanPlayer = new Player();
  //Criando a populacao
  //Setado inicialmente com 200 individuos
  pop = new Population(200);
  //Taxa de atualizacao
  frameRate(speed);
  //Setando o tipo de fonte
  font = loadFont("AgencyFB-Reg-48.vlw");
}

//------------------------------------------------------------------------------------------------------------------------------------------

//Desenhando o jogador
void draw() {
  //deep space background
  //Fundo do espaco profundo
  //Cor do jogador
  background(0);
  //if the user is controling the ship
  //Se o usuario estiver controlando 
  if (humanPlaying) {
    //if the player isnt dead then move and show the player based on input
    //Se o jogador ainda nao morreu
    if (!humanPlayer.dead) {
      //Atualiza o jogador
      humanPlayer.update();
      //Mostra o jogador
      humanPlayer.show();
    } else {
      //once done return to ai
      //Se o jogador morrer, muda a variavel e comeca a gerar o AG
      humanPlaying = false;
    }
  } else 
  // if replaying the best ever game
  // se repetir o melhor jogo de sempre
  if (runBest) {
    //if best player is not dead
    // se o melhor jogador não estiver morto
    if (!pop.bestPlayer.dead) {
      pop.bestPlayer.look(); //Ver
      pop.bestPlayer.think(); //Pensar
      pop.bestPlayer.update(); //Atualizar
      pop.bestPlayer.show(); //Mostrar
      
    //once dead
    //Se morreu
    } else {
      //stop replaying it
      //Pare de repetir
      runBest = false;
      //reset the best player so it can play again
      //redefinir o melhor jogador para que ele possa jogar novamente
      pop.bestPlayer = pop.bestPlayer.cloneForReplay();
    }
    
  //if just evolving normally  
  //Apenas evoluindo normalmente
  } else {
    //if any players are alive then update them
    //Se algum jogador ainda estiver vivo, atualize ele
    if (!pop.done()) {
      pop.updateAlive();
    
    //all dead
    //Quando todos morrerem
    } else {
      //Calculo do AG para definir a nova geracao
      pop.calculateFitness(); 
      pop.naturalSelection();
    }
  }
  //display the score
  //Mostrar o score na tela
  showScore();
}
//------------------------------------------------------------------------------------------------------------------------------------------
//Controle para o jogador humano caso ele precise usar
void keyPressed() {
  switch(key) {
  case ' ':
    //if the user is controlling a ship shoot
    //se o usuário estiver controlando uma filmagem de navio
    if (humanPlaying) {
      humanPlayer.shoot();
    
    //if not toggle showBest
    // se não alternar showBest
    } else {
      showBest = !showBest;
    }
    break;
  //play
  //Jogar
  case 'p':
    humanPlaying = !humanPlaying;
    humanPlayer = new Player();
    break; 
  //speed up frame rate
  //acelerar a taxa de quadros
  case '+':
    speed += 10;
    frameRate(speed);
    println(speed);
    break;
    
  //slow down frame rate
  // diminuir a taxa de quadros
  case '-':
    if (speed > 10) {
      speed -= 10;
      frameRate(speed);
      println(speed);
    }
    break;
  
  //halve the mutation rate
  // reduzir pela metade a taxa de mutação
  case 'h':
    globalMutationRate /=2;
    println(globalMutationRate);
    break;
    
  //double the mutation rate
  // dobrar a taxa de mutação
  case 'd':
    globalMutationRate *= 2;
    println(globalMutationRate);
    break;
    
  //run the best
  // execute o melhor
  case 'b':
    runBest = true;
    break;
  }
  
  //player controls
  // controles do player
  if (key == CODED) {
    if (keyCode == UP) {
      humanPlayer.boosting = true;
    }
    if (keyCode == LEFT) {
      humanPlayer.spin = -0.08;
    } else if (keyCode == RIGHT) {
      humanPlayer.spin = 0.08;
    }
  }
}

void keyReleased() {
  //once key released
  // uma vez liberada a chave
  if (key == CODED) {
    //stop boosting
    // pare de aumentar
    if (keyCode == UP) {
      humanPlayer.boosting = false;
    }
    // stop turning
    // parar de girar
    if (keyCode == LEFT) {
      humanPlayer.spin = 0;
    } else if (keyCode == RIGHT) {
      humanPlayer.spin = 0;
    }
  }
}

//------------------------------------------------------------------------------------------------------------------------------------------
//function which returns whether a vector is out of the play area
//função que retorna se um vetor está fora da área de jogo
boolean isOut(PVector pos) {
  if (pos.x < -50 || pos.y < -50 || pos.x > width+ 50 || pos.y > 50+height) {
    return true;
  }
  return false;
}

//------------------------------------------------------------------------------------------------------------------------------------------
//shows the score and the generation on the screen
//Mostrar o score na tela
void showScore() {
  
  //Alterado esta parte, os elementos sao comuns a todos entao somente altera o tipo de score que vai aparecer

  //Usando a fonte
  textFont(font);
  //Setando a cor
  fill(255);
  //Posicionamento do texto
  textAlign(LEFT);

  //Mostrando o score
  if (humanPlaying) {
    text("Score: " + humanPlayer.score, 80, 60);
  } else
    if (runBest) {
      text("Score: " + pop.bestPlayer.score, 80, 60);
      text("Gen: " + pop.gen, width-200, 60);
    } else {
      if (showBest) {
        text("Score: " + pop.players[0].score, 80, 60);
        text("Gen: " + pop.gen, width-200, 60);
      }
    }
}
