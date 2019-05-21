//Recomentando o code de processing

//Criando a populacao de naves para o jogo
class Population {

  //Atributos da classe populacao
  
  //all dem players -> 
  //Todos os jogadores
  Player[] players;
  //the position in the array that the best player of this generation is in ->
  //Captura a posicao da matriz do melhor jogador atual
  int bestPlayerNo;
  //Valor da geracao
  int gen = 0;
  //the best ever player -> 
  //O melhor jogador de sempre
  Player bestPlayer;
  //Melhor pontuacao
  int bestScore=0;
  //------------------------------------------------------------------------------------------------------------------------------------------
  //constructor
  //Construtor
  //Criando um novo player quando acionar uma classe
  Population(int size) {
    //Novo player no array
    players = new Player[size];
    //Repeticao para a criacao
    for (int i =0; i<players.length ; i++) {
      //criando novos jogadores
      players[i] = new Player();
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //update all the players which are alive
  // atualiza todos os jogadores que estão vivos
  //Atualizar quem esta vivo
  void updateAlive() {
    
    //Contador dos players
    for (int i = 0; i< players.length; i++) {
      //Se determinado player no contator ainda ta vivo, entao faca
      if (!players[i].dead) {
        //get inputs for brain
        //recebe entradas para o cérebro        
        players[i].look();
        //use outputs from neural network
        // use saídas da rede neural
        players[i].think();
        //move the player according to the outputs from the neural network
        // move o jogador de acordo com as saídas da rede neural
        players[i].update();
        
        //dont show dead players
        // não mostra jogadores mortos
        //Esquece os mortos
        if (!showBest || i ==0) {
          //Mostrar os jogadores
          players[i].show();
        }
      }
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //sets the best player globally and for this gen
  // define o melhor jogador globalmente e para este gen
  void setBestPlayer() {
    //get max fitness
    //Pegar o que tem o melhor fitness
    //valor do melhor fitness
    float max =0;
    //posicao do melhor fitness
    int maxIndex = 0;
    //Pegando o melhor fitness comparando todos os jogadores
    for (int i =0; i<players.length; i++) {
      //Comparando com o melhor
      if (players[i].fitness > max) {
        //Se o fitness do atual for melhor que o max, atribua o valor desse fitness no Max
        max = players[i].fitness;
        //Posicionamento do melhor
        maxIndex = i;
      }
    }

    bestPlayerNo = maxIndex;
    //if best this gen is better than the global best score then set the global best as the best this gen
    //se o melhor desta geração é melhor que a melhor pontuação global então defina o melhor global como o melhor desta geração

    if (players[bestPlayerNo].score > bestScore) {
      bestScore = players[bestPlayerNo].score; //Melhor score
      bestPlayer = players[bestPlayerNo].cloneForReplay(); //Melhor player
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  //returns true if all the players are dead
  //retorna verdadeiro se todos os jogadores estiverem mortos
  //Reinicia a geracao
  boolean done() {
    //Contador para verificar todos os jogadores
    for (int i = 0; i< players.length; i++) {
      //Confirma todos os jogadosres
      if (!players[i].dead) {
        //Significa que ainda ta vivo
        return false;
      }
    }
    //Caso retorne true, quer dizer que todo mundo morreu
    return true;
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //creates the next generation of players by natural selection
  // cria a próxima geração de jogadores por seleção natural
  void naturalSelection() {

    //Create new players array for the next generation
    //Cria novos jogados no array para a proxima geracao
    Player[] newPlayers = new Player[players.length];

    //set which player is the best
    // define qual jogador é o melhor
    setBestPlayer();

    //add the best player of this generation to the next generation without mutation
    // adiciona o melhor jogador desta geração à próxima geração sem mutação
    newPlayers[0] = players[bestPlayerNo].cloneForReplay();
    
    //For para repassar todos os jogadores no processo de selecao
    for (int i = 1; i<players.length; i++) {
      //for each remaining spot in the next generation
      // para cada ponto restante na próxima geração
      if (i<players.length/2) {
        // selecione um jogador aleatório (baseado em aptidão) e clone-o
        newPlayers[i] = selectPlayer().clone();
      } else {
        //Novo jogador via passar pelo crossover com outro para gerar o novo jogador
        newPlayers[i] = selectPlayer().crossover(selectPlayer());
      }
      //mutate it
      //mutar novos jogadores
      newPlayers[i].mutate(); 
    }

    //Criando o clone e incrementado os genes
    players = newPlayers.clone();
    //incrementando o gen
    gen+=1;
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  //chooses player from the population to return randomly(considering fitness)
  // escolhe o jogador da população para retornar aleatoriamente (considerando a aptidão)

  Player selectPlayer() {
    //this function works by randomly choosing a value between 0 and the sum of all the fitnesses
    //then go through all the players and add their fitness to a running sum and if that sum is greater than the random value generated that player is chosen
    //since players with a higher fitness function add more to the running sum then they have a higher chance of being chosen
    
    // esta função trabalha escolhendo aleatoriamente um valor entre 0 e a soma de todas as adequações
    // depois passe por todos os jogadores e adicione sua adequação a uma soma corrente e se essa soma for maior que o valor aleatório gerado este jogador é escolhido
    // já que os jogadores com uma função de condicionamento físico mais alta adicionam mais à soma corrente, então eles têm uma chance maior de serem escolhidos

    //calculate the sum of all the fitnesses
    // calcula a soma de todas as aptidões
    long fitnessSum = 0;
    //Criando o somador
    for (int i =0; i<players.length; i++) {
      //Realizando a somatoria
      fitnessSum += players[i].fitness;
    }
    
    //Somente capture o inteiro do random da soma dos fitness
    int rand = floor(random(fitnessSum));
    
    //summy is the current fitness sum
    // summy é a soma atual de adequação
    int runningSum = 0;

    //Passe por todos os jogadores
    for (int i = 0; i< players.length; i++) {
      //Realizando a somatoria
      runningSum += players[i].fitness;
      //Verificando que e superior ao valor rand acima
      if (runningSum > rand) {
        //Retorno do jogador
        return players[i];
      }
    }
    //unreachable code to make the parser happy
    //código inacessível para tornar o analisador feliz
    return players[0];
  }

  //------------------------------------------------------------------------------------------------------------------------------------------

  //mutates all the players
  //mutacao em todos os jogadores
  void mutate() {
    //Taxa de mustacao para todos os jogadores
    for (int i =1; i<players.length; i++) {
      //Passando pela funcao de mutacao
      players[i].mutate();
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  
  //calculates the fitness of all of the players
  //Calculo da taxa de refinamento de todos os players
  void calculateFitness() {
    //For para fazer em todos os jogadores
    for (int i =1; i<players.length; i++) {
      //Passando pela funcao de calcular o fitness
      players[i].calculateFitness();
    }
  }
}
