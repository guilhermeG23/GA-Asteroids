//Criando a classe da bala da aeronave
class Bullet {
  //Atributos da classe
  
  //Criando o vetor de posicao
  PVector pos;
  //Criando o vetor de velocidade
  PVector vel;
  //Velocidade
  float speed = 10;
  //Mostrar o tiro
  //Isso e como se existe ou nao o tiro
  boolean off = false;
  //Tempo de vida do tiro
  int lifespan = 60;
  
  //------------------------------------------------------------------------------------------------------------------------------------------
  //Criando o tiro
  Bullet(float x, float y, float r, float playerSpeed) {
    //Capturando a posicao atual
    pos = new PVector(x, y);
    //Velocidade
    vel = PVector.fromAngle(r);
    //bullet speed = 10 + the speed of the player
    //velocidade do marcador = 10 + a velocidade do jogador
    vel.mult(speed + playerSpeed);
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  //move the bullet
  //Movimento do tiro
  void move() {
    //Decremento da vida do tiro
    lifespan --;
    //Se o tiro tiver uma vida acima de zero, ele ainda existe, se nao ele some
    if (lifespan<0) {
      //if lifespan is up then destroy the bullet
      // se o tempo de vida acabar, destrua a bala -> Tempo de vida to tiro
      off = true;
    } else {
      pos.add(vel);   
      if (isOut(pos)) {
        //wrap bullet
        //Embulhar o tiro
        loopy();
      }
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  //show a dot representing the bullet
  // mostra um ponto representando o marcador
  void show() {
    //Se tiro for !false = true, ele desenha
    if (!off) {
      //Cor do tiro
      fill(255);
      //Desenho do tiro
      ellipse(pos.x, pos.y, 3, 3);
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  //if out moves it to the other side of the screen
  //se sair move para o outro lado da tela
  //Mesma funcao de loop dos asteroides, ele so mostra o loop do tiro entrando numa parede e saindo o contrario
  void loopy() {
    if (pos.y < -50) {
      pos.y = height + 50;
    } else
      if (pos.y > height + 50) {
        pos.y = -50;
      }
    if (pos.x< -50) {
      pos.x = width +50;
    } else  if (pos.x > width + 50) {
      pos.x = -50;
    }
  }
}   
