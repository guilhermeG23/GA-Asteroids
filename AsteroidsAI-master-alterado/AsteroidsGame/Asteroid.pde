//Classe para a criacao dos asteroides
class Asteroid {
  //Criando um componente com vetor
  PVector pos;
  PVector vel; 
  //Exemplificando o tamanho dos asteroides 
  //Acrescentado o modelo 4 e 5
  //5 = Emuch very large -> norme
  //4 = very large -> Muito grande
  //3 = large -> Grande
  //2 = medium -> Medio
  //1 = small -> Pequeno
  int size = 5;
  //Criando o raio
  float radius;
  //each asteroid contains 2 smaller asteroids which are released when shot
  //cada asteróide contém 2 asteróides menores que são liberados quando disparados
  ArrayList<Asteroid> chunks = new ArrayList<Asteroid>();
  //whether the asteroid has been hit and split into to 2
  //se o asteróide foi atingido e dividido em 2
  boolean split = false;
  
  //------------------------------------------------------------------------------------------------------------------------------------------
  //constructor 
  //Construtor do asteroide
  Asteroid(float posX, float posY, float velX, float velY, int sizeNo) {
    
    //Criando novos vetores
    pos = new PVector(posX, posY);
    vel = new PVector(velX, velY);
    size = sizeNo;
    
    //Switch para saber qual escolher e quais caracteristicas possuir
    switch(sizeNo) {
    //set the velocity and radius depending on size
    //Setando a velocidade e raio dependente pelo tamanho
    //pequeno asteroid
    case 1:
      radius = 15;
      vel.normalize();
      vel.mult(1.50);
      break;
    //Medio asteriod
    case 2:
      radius = 30;
      vel.normalize();
      vel.mult(1.25);
      break;
    //Grande asteroid
    case 3:
      radius = 60;
      vel.normalize();
      vel.mult(1);
      break;
    //Maior asteroid
    case 4:
      radius = 120;
      vel.normalize();
      vel.mult(0.75);
      break;
    //Enome asteroid
    case 5:
      radius = 150;
      vel.normalize();
      vel.mult(0.50);
      break;
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  //draw the asteroid
  //Desenhar os asteroides
  void show() {
    //if split show the 2 chunks
    // se split mostrar os 2 pedaços
    if (split) {
      //Asteroide dividido, mostre os pedacos
      for (Asteroid a : chunks) {
        //Mostrando os pedacos
        a.show();
      }
    } else {
      // if still whole ->
      //Se ainda inteiro
      //Sem cor
      noFill();
      //Colocando a borda
      stroke(255);
      //Polygon suas 4 entradas:
      //x -> posicionamento x
      //y -> posicionamemto y
      //radius -> raio
      //12 -> Quantidade de poligos / Lados do asteroide
      polygon(pos.x, pos.y, radius, 12);
      //draw the dodecahedrons
      //Desenhar os dodecaedros
    }
  }
//--------------------------------------------------------------------------------------------------------------------------
  
  //Funcao do polygon
  //Link: https://processing.org/examples/regularpolygon.html

  //draws a polygon 
  //Desenhar os poligonos
  void polygon(float x, float y, float radius, int npoints) {
    //set the angle between vertexes
    // define o ângulo entre vértices
    float angle = TWO_PI / npoints;
    beginShape();
    //draw each vertex of the polygon
    //Desenha cada vertice do poligono
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * radius;//math
      float sy = y + sin(a) * radius;//math
      vertex(sx, sy);
    }
    //Fechamento do desenho
    endShape(CLOSE);
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //adds the velocity to the position
  //adiciona a velocidade à posição
  void move() {
    //if split move the chunks
    //se dividir, mova os pedaços
    if (split) {
      for (Asteroid a : chunks) {
        a.move();
      }
     
    //if not split
    //Se nao dividir
    } else {
      //move it
      //Mova isso
      pos.add(vel);
      //if out of the playing area wrap (loop) it to the other side
      // se fora da área de jogo, enrole (loop) no outro lado
      if (isOut(pos)) {
        //Iniciar a funcao de loopy da classe
        loopy();
      }
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //if out moves it to the other side of the screen
  // se sair move para o outro lado da tela
  //Funcao de loop da tela tem como objetivo reaparecer o objeto ao lado contrario da tela
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
  //------------------------------------------------------------------------------------------------------------------------------------------
  //checks if a bullet hit the asteroid
  //verifica se uma bala atingiu o asteróide
  boolean checkIfHit(PVector bulletPos) {
    //if split check if the bullet hit one of the chunks
    //se dividir verificar se o marcador atingiu um dos pedaços
    //Verificar se o asteroide se dividiu com o tiro
    if (split) {
      for (Asteroid a : chunks) {
        if (a.checkIfHit(bulletPos)) {
          //Retonar que esta quebrado a aporacao
          return true;
        }
      }
      //Retornar ao estado atual
      return false;
    } else {
      //if it did hit
      // se foi atingido
      if (dist(pos.x, pos.y, bulletPos.x, bulletPos.y)< radius) {
        //Boom
        //Operacao para decidir o que acontece ao asteroide depois de ser atingido
        isHit();
        //Retorno verdade
        return true;
      }
      //Retorno falso
      return false;
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //probs could have made these 3 functions into 1 but whatever
  //this one checks if the player hit the asteroid
  // probs poderia ter feito essas 3 funções em 1, mas seja qual for
  // este verifica se o jogador atingiu o asteróide
  boolean checkIfHitPlayer(PVector playerPos) {
    //if split check if the player hit one of the chunks
    //se dividir, verifique se o jogador atingiu um dos pedaços
    if (split) {
      for (Asteroid a : chunks) {
        if (a.checkIfHitPlayer(playerPos)) {
          return true;
        }
      }
      return false;
    } else {
      //if hit player
      //Se acertar o jogador
      if (dist(pos.x, pos.y, playerPos.x, playerPos.y)< radius + 15) {
        //boom
        //Confirma se foi acertado
        isHit();
        //Retorno true
        return true;
      }
      //Ta vivo, retorno false
      return false;
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  //same as checkIfHit but it doesnt destroy the asteroid used by the look function
  //mesmo que checkIfHit mas não destrói o asteróide usado pela função look
  boolean lookForHit(PVector bulletPos) {
    if (split) {
      for (Asteroid a : chunks) {
        if (a.lookForHit(bulletPos)) {
          return true;
        }
      }
      return false;
    } else {
      if (dist(pos.x, pos.y, bulletPos.x, bulletPos.y)< radius) {
        return true;
      }
      return false;
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //destroys/splits asteroid
  //Destruir/Dividir o asteroide
  void isHit() {
    split = true;
    if (size == 1) {
      //can't split the smallest asteroids
      //nao pode dividir asteroides muito pequenos
      return;
    } else {
      //add 2 smaller asteroids to the chunks array with slightly different velocities
      //adicione 2 asteróides menores à matriz de pedaços com velocidades ligeiramente diferentes
      PVector velocity = new PVector(vel.x,vel.y);
      //A divisao dos asteroides vai ser feita com um pedaco tento uma velocidade diferente do outro
      velocity.rotate(-0.3); //Parte dividida 1
      chunks.add(new Asteroid(pos.x, pos.y, velocity.x, velocity.y , size-1)); 
      velocity.rotate(0.5); //parte dividida 2
      chunks.add(new Asteroid(pos.x, pos.y, velocity.x, velocity.y , size-1)); 
    }
  }
}
