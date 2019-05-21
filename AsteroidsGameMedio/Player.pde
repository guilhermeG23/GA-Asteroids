//Criando a classe para o player
class Player {

  //-----Funcionamento normal para o jogador

  //Criando os atributos
  PVector pos; //Vetor da posicao 
  PVector vel; //vetor da velocidade 
  PVector acc; //vetor da aceleracao
  //how many asteroids have been shot
  //quantos asteróides foram disparados
  //Pontuacao do cara depois de acertar qualquer asteroide
  int score = 0;
  //stops the player from shooting too quickly
  //impede o jogador de disparar muito rapidamente
  int shootCount = 0;
  //the ships current rotation
  //A rotação atual dos navios
  float rotation;
  //the amount the ship is to spin next update
  //o valor que o navio deve girar na próxima atualização
  float spin;
  //limit the players speed at 10
  //Limite de velocidade na movimentacao do jogador
  float maxSpeed = 10;
  //whether the booster is on or not
  // se o booster está ligado ou não
  boolean boosting = false;
  //the bullets currently on screen
  //Posicao atual dos tiros do determinado jogador
  ArrayList<Bullet> bullets = new ArrayList<Bullet>(); 
  //Posicao atual dos asteroides
  ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
  //the time until the next asteroid spawns
  // o tempo até o próximo asteróide aparecer
  //Tempo de spaw dos asteroides
  int asteroidCount = 1000;
  //Quantidaded de vivos
  int lives = 0;
  //Saber se o jogador morreu
  boolean dead = false;
  //when the player looses a life and respawns it is immortal for a small amount of time
  // quando o jogador perde uma vida e reaparece, é imortal por um pequeno período de tempo
  //Esse daqui serve mais para quando alguem que ta jogando, tipo, respaw invuneravel
  int immortalCount = 0;   
  //makes the booster flash
  //faz o booster flash
  int boostCount = 10;

  //Quantidade de repeticoes dos summoners dos asteroids
  int quantidade_sumonner = 4;

  //--------AI stuff
  // -------- coisas de AI
  //---------Funcionamento para a IA jogar 

  //Chamando a classe NeuralNet e atribuindo os valores a brain
  NeuralNet brain;

  //the input array fed into the neuralNet
  // o array de entrada alimentado na neuralnet
  float[] vision = new float[8];
  //the out put of the NN 
  // a saída do NN
  float[] decision = new float[4];
  //whether the player is being raplayed
  // se o jogador está sendo repetido
  boolean replay = false;  

  //since asteroids are spawned randomly when replaying the player we need to use a random seed to repeat the same randomness
  // já que os asteróides são gerados aleatoriamente ao reproduzir o jogador, precisamos usar uma semente aleatória para repetir a mesma aleatoriedade
  //the random seed used to intiate the asteroids
  // a semente aleatória usada para iniciar os asteróides
  long SeedUsed;

  //seeds used for all the spawned asteroids
  // sementes usadas para todos os asteróides gerados
  ArrayList<Long> seedsUsed = new ArrayList<Long>();
  //which position in the arrayList
  // qual posição no arrayList
  int upToSeedNo = 0;

  //Criando o fitness
  float fitness;

  //initiated at 4 to encourage shooting
  // iniciado às 4 para incentivar o disparo
  int shotsFired =4;
  //initiated at 1 so players dont get a fitness of 1
  // iniciou em 1 para que os jogadores não tenham uma aptidão de 1
  int shotsHit = 1; 

  //how long the player lived for fitness
  // quanto tempo o jogador viveu por aptidão
  int lifespan = 0;

  //whether the player can shoot or not
  // se o jogador pode atirar ou não
  boolean canShoot = true;
  //------------------------------------------------------------------------------------------------------------------------------------------
  //constructor
  //Construtor
  Player() {
    //Criando os vetores
    pos = new PVector(width/2, height/2); //Posicao
    vel = new PVector(); //Velocidade
    acc = new PVector(); //Aceleracao
    //Rotacao
    rotation = 0;
    //create and store a seed
    // cria e armazena uma semente
    SeedUsed = floor(random(1000000000)); //Semente
    //Randimico entre a geracao das sementes
    randomSeed(SeedUsed); //Semente randomica

    //Linhas comentadas somente para presevar o original, trocados por função abaixo

    //generate asteroids
    //Gerando os asteroides
    //Alterado ultimo valor, para mandar asteroids maiores que o 3 por padrao, tamanho atual 4
    //asteroids.add(new Asteroid(random(width), 0, random(-1, 1), random (-1, 1), 3));
    //asteroids.add(new Asteroid(random(width), 0, random(-1, 1), random (-1, 1), 4));
    //Retirando, linha clonada
    //asteroids.add(new Asteroid(random(width), 0, random(-1, 1), random (-1, 1), 3));
    //asteroids.add(new Asteroid(random(width), 0, random(-1, 1), random (-1, 1), 4));
    //asteroids.add(new Asteroid(0, random(height), random(-1, 1), random (-1, 1), 4));
    //asteroids.add(new Asteroid(random(width), random(height), random(-1, 1), random (-1, 1), 4));
    
    //Juntando todos os summoners de asteroids
    //Repete o for até criar uma boa quantidade de alvos para a nave
    for (int i = 0; i <= quantidade_sumonner; i++) {
      asteroids.add(new Asteroid(random(width), 0, random(-1, 1), random(-1, 1), int(random(1, 5)))); 
      asteroids.add(new Asteroid(random(width), 610, random(-1, 1), random(-1, 1), int(random(1, 5))));   
      asteroids.add(new Asteroid(0, random(height), random(-1, 1), random(-1, 1), int(random(1, 5))));
      asteroids.add(new Asteroid(1260, random(height), random(-1, 1), random(-1, 1), int(random(1, 5))));
      asteroids.add(new Asteroid(random(width), random(height), random(-1, 1), random(-1, 1), int(random(1, 5))));
      //aim the fifth one at the player
      // apontar o quinto no jogador
      float randX = random(width);
      float randY = -50 +floor(random(2))* (height+100);
      asteroids.add(new Asteroid(randX, randY, pos.x- randX, pos.y - randY, int(random(1, 5))));
      asteroids.add(new Asteroid(randX, randY, pos.x- randX, pos.y - randY, int(random(1, 5))));
    }
    //Cerebro, nova inteligencia
    brain = new NeuralNet(9, 16, 4);
  }
  //----------------------------++++++--------------------------------------------------------------------------------------------------------------
  //constructor used for replaying players
  // construtor usado para reproduzir jogadores
  Player(long seed) {
    //is replaying
    // está repetindo
    replay = true;
    pos = new PVector(width/2, height/2); //Posicao
    vel = new PVector(); //Velocidade
    acc = new PVector(); //Aceleracao  
    //Rotacao
    rotation = 0;
    //use the parameter seed to set the asteroids at the same position as the last one
    // use o parâmetro seed para definir os asteróides na mesma posição que o último
    SeedUsed = seed; //Adicionando semente para o semente do usuario
    randomSeed(SeedUsed); //Semente
    
    //Linhas comentadas somente para presevar o original, trocados por função abaixo
    
    //generate asteroids
    //Gerar os asteroides
    //asteroids.add(new Asteroid(random(width), 0, random(-1, 1), random (-1, 1), 3));
    //Retirando, linha clonada
    //asteroids.add(new Asteroid(random(width), 0, random(-1, 1), random (-1, 1), 3));
    //asteroids.add(new Asteroid(0, random(height), random(-1, 1), random (-1, 1), 3));
    //asteroids.add(new Asteroid(random(width), random(height), random(-1, 1), random (-1, 1), 3));

    //Passa pelo for para criar uma boa quantidade de alvos para a nave
    //Juntando todos os summoners de asteroids
    for (int i = 0; i <= quantidade_sumonner; i++) {
      //Juntando todos os summoners de asteroids
      asteroids.add(new Asteroid(random(width), 0, random(-1, 1), random(-1, 1), int(random(1, 5)))); 
      asteroids.add(new Asteroid(random(width), 610, random(-1, 1), random(-1, 1), int(random(1, 5))));   
      asteroids.add(new Asteroid(0, random(height), random(-1, 1), random(-1, 1), int(random(1, 5))));
      asteroids.add(new Asteroid(1260, random(height), random(-1, 1), random(-1, 1), int(random(1, 5))));
      asteroids.add(new Asteroid(random(width), random(height), random(-1, 1), random(-1, 1), int(random(1, 5))));
      //aim the fifth one at the player
      // apontar o quinto no jogador
      float randX = random(width);
      float randY = -50 +floor(random(2))* (height+100);
      asteroids.add(new Asteroid(randX, randY, pos.x- randX, pos.y - randY, int(random(1, 5))));
      asteroids.add(new Asteroid(randX, randY, pos.x- randX, pos.y - randY, int(random(1, 5))));
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  //Move player
  //Mover o jogador
  void move() {
    if (!dead) {
      checkTimers(); //Check os players
      rotatePlayer(); //Rode os players
      //are thrusters on
      // são thrusters no
      if (boosting) {
        boost(); //Com boost
      } else {
        boostOff(); //Sem boost -> propulsao
      }

      //velocity += acceleration
      //Vetor de aceleracao
      vel.add(acc);

      //limite maximo de um vertor
      vel.limit(maxSpeed);
      
      //Multiplicador um vetr or um escalar
      vel.mult(0.99);

      //position += velocity
      pos.add(vel);

      //move all the bullets
      //Mova todos os tiros
      //Contador
      for (int i = 0; i < bullets.size(); i++) {
        //Move determinado tiro
        bullets.get(i).move();
      }

      //move all the asteroids
      //Mova todos os asteroides
      //Contador
      for (int i = 0; i < asteroids.size(); i++) {
        //Mover determinado asteroid
        asteroids.get(i).move();
      }

      //wrap the player around the gaming area
      // enrole o jogador ao redor da área de jogo
      if (isOut(pos)) {
        loopy(); //Criando o loop
      }
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //move through time and check if anything should happen at this instance
  // percorrer o tempo e verificar se algo deve acontecer nesta instância
  void checkTimers() {
    //Almenta o tempo
    lifespan +=1;
    //Decremente o tiro
    shootCount --;
    //Decrementa o asteroid
    asteroidCount--;

    //spawn asteorid
    //espauna asteroide
    if (asteroidCount<=0) {

      //if replaying use the seeds from the arrayList
      // se o replaying usar as sementes do arrayList
      if (replay) {
        //Uso da semente randomica
        randomSeed(seedsUsed.get(upToSeedNo));
        //Incremento da semente
        upToSeedNo ++;

        //if not generate the seeds and then save them
        // se não gerar as sementes e depois salvá-las
      } else {
        //Semente
        long seed = floor(random(1000000));
        //Semente do usuario
        seedsUsed.add(seed);
        //Semente randomico
        randomSeed(seed);
      }
      //aim the asteroid at the player to encourage movement
      // apontar o asteróide no jogador para estimular o movimento
      float randX = random(width);
      float randY = -50 +floor(random(2))* (height+100);
      asteroids.add(new Asteroid(randX, randY, pos.x- randX, pos.y - randY, int(random(1, 5))));
      asteroidCount = 1000;
    }

    //Contador do tiro
    if (shootCount <=0) {
      canShoot = true;
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  //booster
  //impulsionador
  void boost() {
    //Determinando o boots
    acc = PVector.fromAngle(rotation);
    //ativando o buste -> Aceleracao
    acc.setMag(0.1);
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  //boostless
  //sem impulso
  void boostOff() {
    //Diminuindo a aceleracao
    acc.setMag(0);
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //spin that player
  // gira esse jogador
  void rotatePlayer() {
    //Incrementacao para rotacao
    rotation += spin;
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //draw the player, bullets and asteroids 
  //Desenhe o jogador, balas e asteroides
  void show() {
    //Se nao morreu ainda 
    if (!dead) {
      //show bullets
      //Mostre as balas
      for (int i = 0; i < bullets.size(); i++) {
        //Mostre as balas de cada jogador
        bullets.get(i).show();
      }
      //no need to decrease immortalCOunt if its already 0
      //Nao ha a necessidade de diminuir immortalCount se ele ja e 0
      if (immortalCount >0) {
        //Decremento de imortalidade
        immortalCount --;
      }
      //needs to appear to be flashing so only show half of the time
      // precisa parecer estar piscando, então mostre apenas metade do tempo
      if (immortalCount >0 && floor(((float)immortalCount)/5)%2 ==0) {
        //Nao tem nada no if
      } else {
        //Manda matriz
        pushMatrix();
        //Translatar
        translate(pos.x, pos.y);
        //Rotacao
        rotate(rotation);
        //actually draw the player
        // realmente desenha o jogador
        //Cor
        fill(0);
        noStroke();
        beginShape();
        int size = 12;
        //black triangle
        //Triangulo preto, back da nave
        vertex(-size-2, -size);
        vertex(-size-2, size);
        vertex(2* size -2, 0);
        //Terminando o desenho
        endShape(CLOSE);
        stroke(255);
        //white out lines
        //Desenho da nave
        line(-size-2, -size, -size-2, size);
        line(2* size -2, 0, -22, 15);
        line(2* size -2, 0, -22, -15);
        //when boosting draw "flames" its just a little triangle
        // ao impulsionar desenhar "chamas" é apenas um pequeno triângulo
        if (boosting ) {
          boostCount --;
          //only show it half of the time to appear like its flashing
          // mostra apenas metade do tempo para aparecer como se estivesse piscando
          if (floor(((float)boostCount)/3)%2 ==0) {
            line(-size-2, 6, -size-2-12, 0);
            line(-size-2, -6, -size-2-12, 0);
          }
        }
        popMatrix();
      }
    }
    //show asteroids
    //Mostrar asteroides
    for (int i = 0; i < asteroids.size(); i++) {
      asteroids.get(i).show();
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //shoot a bullet
  //Atirando
  void shoot() {
    //if can shoot
    //Se pode disparar
    if (shootCount <=0) {
      //create bullet
      //Criando a bala
      bullets.add(new Bullet(pos.x, pos.y, rotation, vel.mag()));
      //reset shoot count
      //redefinir a contagem de disparos
      shootCount = 30;
      canShoot = false;
      shotsFired ++;
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //in charge or moving everything and also checking if anything has been shot or hit
  // encarregado ou movendo tudo e também checando se alguma coisa foi disparada ou atingida
  void update() {
    //if any bullets expires remove it
    // se algum disparo expirar, remova-o
    for (int i = 0; i < bullets.size(); i++) {
      if (bullets.get(i).off) {
        bullets.remove(i);
        i--;
      }
    }    
    //move everything
    //Move tudo
    move();
    //check if anything has been shot or hit
    // verifique se alguma coisa foi disparada ou atingida
    checkPositions();
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //check if anything has been shot or hit
  // verifique se alguma coisa foi disparada ou atingida
  void checkPositions() {
    //check if any bullets have hit any asteroids
    // verifique se alguma bala atingiu algum asteroide
    //Tempo de vida das balas
    //Contador de balas
    for (int i = 0; i < bullets.size(); i++) {
      //Contador de asteroids
      for (int j = 0; j < asteroids.size(); j++) {
        if (asteroids.get(j).checkIfHit(bullets.get(i).pos)) {
          //Incrementada o tiro
          shotsHit ++;
          //remove bullet
          //Remove as balas
          bullets.remove(i);
          //Incremento do score
          score +=1;
          //Quebra
          break;
        }
      }
    }
    //check if player has been hit
    // checar se o jogador foi atingido
    if (immortalCount <=0) {
      //Contador
      for (int j = 0; j < asteroids.size(); j++) {
        //Pega os asteroids e confirma se acertou algo
        if (asteroids.get(j).checkIfHitPlayer(pos)) {
          //Player acerteado
          playerHit();
        }
      }
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //called when player is hit by an asteroid
  // chamado quando o jogador é atingido por um asteróide
  void playerHit() {
    //if no lives left
    // se não houver mais vidas
    if (lives == 0) {
      //Atribuir a morte a todos
      dead = true;

    //remove a life and reset positions
    // Remova uma vida e reinicie a posição
    } else {
      lives -=1; //decrementos na vida
      immortalCount = 100; //Contador de imortalidade
      resetPositions(); //Ponto de reset -> respanw
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //returns player to center
  // retorna o jogador ao centro
  void resetPositions() {
    pos = new PVector(width/2, height/2); //Vetor de posicao
    vel = new PVector(); //Vetor de velocidade
    acc = new PVector();  //Vetor de aceleracao
    bullets = new ArrayList<Bullet>(); //Array de tiros
    rotation = 0; //Zerando a rotacao para comecarem iguais
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //wraps the player around the playing area
  // envolve o jogador em volta da área de jogo
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

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //for genetic algorithm
  //Para o AG
  void calculateFitness() {
    //Tiro
    float hitRate = (float)shotsHit/(float)shotsFired;
    //Placar
    //Fitnees
    fitness = (score+1)*10;
    //Tempo de vida
    fitness *= lifespan;
    //includes hitrate to encourage aiming
    // inclui hitrate para incentivar o objetivo
    fitness *= hitRate*hitRate;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //Mutacao
  void mutate() {
    //muta puxando a rede Neural
    brain.mutate(globalMutationRate);
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //returns a clone of this player with the same brian
  // retorna um clone deste jogador com o mesmo cerebro
  Player clone() {
    //Novo player = clone
    Player clone = new Player();
    //Clonar inteligencia 
    clone.brain = brain.clone();
    //Retornando clone do player
    return clone;
  }
  //returns a clone of this player with the same brian and same random seeds used so all of the asteroids will be in  the same positions
  // retorna um clone deste jogador com o mesmo cerebro e as mesmas sementes aleatórias usadas para que todos os asteróides estejam nas mesmas posições
  Player cloneForReplay() {
    //Clonando o player atual com a semente
    Player clone = new Player(SeedUsed);
    //Clonando a inteligencia
    clone.brain = brain.clone();
    //Chamando a funcao das sementes
    clone.seedsUsed = (ArrayList)seedsUsed.clone();
    //Retornando o clone
    return clone;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //Crossover
  Player crossover(Player parent2) {
    Player child = new Player(); //Cria um novo filho
    child.brain = brain.crossover(parent2.brain); //Criando a crianca
    return child; //Retorna a crianca
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  

  //looks in 8 directions to find asteroids
  // olha em 8 direções para encontrar asteróides
  void look() {
    vision = new float[9];
    //look left
    //Olha a esquerda
    PVector direction;
    for (int i = 0; i< vision.length; i++) {
      direction = PVector.fromAngle(rotation + i*(PI/4));
      direction.mult(10);
      vision[i] = lookInDirection(direction);
    }

    if (canShoot && vision[0] !=0) {
      vision[8] = 1;
    } else {
      vision[8] =0;
    }
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  


  //Olhando para um vetor
  float lookInDirection(PVector direction) {
    //set up a temp array to hold the values that are going to be passed to the main vision array
    // configura uma matriz temporária para conter os valores que serão passados ​​para a matriz de visão principal

    //the position where we are currently looking for food or tail or wall
    // a posição em que estamos atualmente procurando comida ou cauda ou parede
    PVector position = new PVector(pos.x, pos.y);
    float distance = 0;
    //move once in the desired direction before starting
    // mover uma vez na direção desejada antes de começar
    position.add(direction);
    //Incrementada distancia
    distance +=1;

    //look in the direction until you reach a wall
    // olhar na direção até chegar a uma parede
    while (distance< 60) {
      // #Comentado pelo autor -> Trecho acima -> !(position.x < 400 || position.y < 0 || position.x >= 800 || position.y >= 400)) {

      //Posicionamento dos asteroids
      for (Asteroid a : asteroids) {
        if (a.lookForHit(position)) {
          return  1/distance;
        }
      }

      //look further in the direction
      // olhe mais na direção

      //Apontando para determinado vetor
      position.add(direction);

      //loop it
      // faça um loop dentro do video
      if (position.y < -50) {
        position.y += height + 100;
      } else
        if (position.y > height + 50) {
          position.y -= height -100;
        }
      if (position.x< -50) {
        position.x += width +100;
      } else  if (position.x > width + 50) {
        position.x -= width +100;
      }

      //Incrementada distancia
      distance +=1;
    }
    //Retorno de nada = 0
    return 0;
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  

  //saves the player to a file by converting it to a table
  // salva o player em um arquivo convertendo-o em uma tabela
  void savePlayer(int playerNo, int score, int popID) {
    //save the players top score and its population id 
    Table playerStats = new Table();
    playerStats.addColumn("Top Score");
    playerStats.addColumn("PopulationID");
    TableRow tr = playerStats.addRow();
    tr.setFloat(0, score);
    tr.setInt(1, popID);

    saveTable(playerStats, "data/playerStats" + playerNo+ ".csv");

    //save players brain
    // salva o cérebro dos jogadores
    saveTable(brain.NetToTable(), "data/player" + playerNo+ ".csv");
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  

  //return the player saved in the parameter posiition
  // retorna o jogador salvo no parâmetro posiition
  Player loadPlayer(int playerNo) {

    Player load = new Player();
    Table t = loadTable("data/player" + playerNo + ".csv");
    load.brain.TableToNet(t);
    return load;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------      
  //convert the output of the neural network to actions
  // converte a saída da rede neural em ações
  void think() {
    //get the output of the neural network
    // obtém a saída da rede neural
    decision = brain.output(vision);

    //output 0 is boosting
    // saída 0 está aumentando
    if (decision[0] > 0.8) {
      boosting = true;
    } else {
      boosting = false;
    }

    //output 1 is turn left
    // a saída 1 é a esquerda
    if (decision[1] > 0.8) {
      spin = -0.08;

      //cant turn right and left at the same time 
      // não pode virar para a direita e para a esquerda ao mesmo tempo
    } else {
      //output 2 is turn right
      // saída 2 é a direita
      if (decision[2] > 0.8) {
        spin = 0.08;

        //if neither then dont turn
        // se nem depois, não virar
      } else {
        spin = 0;
      }
    }
    //shooting
    //Atirando
    //output 3 is shooting
    // saída 3 está disparando
    if (decision[3] > 0.8) {
      shoot();
    }
  }
}
