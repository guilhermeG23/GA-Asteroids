//Criando a classe de rede neural
class NeuralNet {

  int iNodes;//No. of input nodes -> Entrada
  int hNodes;//No. of hidden nodes -> Escondido
  int oNodes;//No. of output nodes -> Saida
  
  //Utilizando o classe matrix para criar os atributos

  //matrix containing weights between the input nodes and the hidden nodes
  // matriz contendo pesos entre os nós de entrada e os nós ocultos
  Matrix whi;
  
  //matrix containing weights between the hidden nodes and the second layer hidden nodes
  // matriz contendo pesos entre os nós ocultos e os nós ocultos da segunda camada
  Matrix whh;
  
  //matrix containing weights between the second hidden layer nodes and the output nodes
  // matriz contendo pesos entre os segundos nós da camada oculta e os nós de saída
  Matrix woh;

  //constructor
  //Construtor
  NeuralNet(int inputs, int hiddenNo, int outputNo) {

    //set dimensions from parameters
    // definir dimensões a partir de parâmetros
    iNodes = inputs;
    oNodes = outputNo;
    hNodes = hiddenNo;

    //create first layer weights 
    //included bias weight
    // criar pesos da primeira camada
    // peso de polarização incluído
    whi = new Matrix(hNodes, iNodes +1);

    //create second layer weights
    //include bias weight
    // cria pesos da segunda camada
    // inclui peso de polarização
    whh = new Matrix(hNodes, hNodes +1);

    //create second layer weights
    //include bias weight
    // cria pesos da segunda camada
    // inclui peso de polarização
    woh = new Matrix(oNodes, hNodes +1);  

    //set the matricies to random values
    // define as matrizes para valores aleatórios
    whi.randomize();
    whh.randomize(); 
    woh.randomize();
  }

  //mutation function for genetic algorithm
  // função de mutação para algoritmo genético
  void mutate(float mr) {
    //mutates each weight matrix
    // muta cada matriz de peso
    whi.mutate(mr);
    whh.mutate(mr);
    woh.mutate(mr);
  }

  //calculate the output values by feeding forward through the neural network
  // calcula os valores de saída, avançando através da rede neural
  float[] output(float[] inputsArr) {

    //convert array to matrix
    //Note woh has nothing to do with it its just a funciton in the Matrix class
    // converter matriz para matriz
    // Nota woh não tem nada a ver com isso é apenas uma função na classe Matrix
    Matrix inputs = woh.singleColumnMatrixFromArray(inputsArr);

    //add bias
    // adicionar viés
    Matrix inputsBias = inputs.addBias();

    //-----------------------calculate the guessed output
    // ----------------------- calcula a saída adivinhada

    //apply layer one weights to the inputs
    // aplica pesos da camada um às entradas
    Matrix hiddenInputs = whi.dot(inputsBias);

    //pass through activation function(sigmoid)
    // passar pela função de ativação (sigmoid)
    Matrix hiddenOutputs = hiddenInputs.activate();

    //add bias
    // adicionar viés
    Matrix hiddenOutputsBias = hiddenOutputs.addBias();

    //apply layer two weights
    // aplicar camada dois pesos
    Matrix hiddenInputs2 = whh.dot(hiddenOutputsBias);
    Matrix hiddenOutputs2 = hiddenInputs2.activate();
    Matrix hiddenOutputsBias2 = hiddenOutputs2.addBias();

    //apply level three weights
    // aplicar pesos de nível três
    Matrix outputInputs = woh.dot(hiddenOutputsBias2);
    //pass through activation function(sigmoid)
    // passar pela função de ativação (sigmoid)
    Matrix outputs = outputInputs.activate();

    //convert to an array and return
    // converte para um array e retorna
    return outputs.toArray();
  }

  //crossover funciton for genetic algorithm
  // função crossover para algoritmo genético
  NeuralNet crossover(NeuralNet partner) {

    //creates a new child with layer matricies from both parents
    // cria um novo filho com matrizes de camada de ambos os pais
    NeuralNet child = new NeuralNet(iNodes, hNodes, oNodes);
    child.whi = whi.crossover(partner.whi);
    child.whh = whh.crossover(partner.whh);
    child.woh = woh.crossover(partner.woh);
    return child;
  }

  //return a neural net whihc is a clone of this Neural net
  // retorna uma rede neural que é um clone dessa rede neural
  NeuralNet clone() {
    NeuralNet clone  = new NeuralNet(iNodes, hNodes, oNodes); 
    clone.whi = whi.clone();
    clone.whh = whh.clone();
    clone.woh = woh.clone();

    return clone;
  }

  //converts the weights matricies to a single table 
  //used for storing the snakes brain in a file
  // converte as matrizes de pesos em uma única tabela
  // usado para armazenar o cérebro das cobras em um arquivo
  Table NetToTable() {

    //create table
    //criando a tabela
    Table t = new Table();

    //convert the matricies to an array
    // converte as matrizes para um array
    float[] whiArr = whi.toArray();
    float[] whhArr = whh.toArray();
    float[] wohArr = woh.toArray();

    //set the amount of columns in the table
    // define a quantidade de colunas na tabela
    for (int i = 0; i< max(whiArr.length, whhArr.length, wohArr.length); i++) {
      t.addColumn();
    }

    //set the first row as whi
    // define a primeira linha como whi
    TableRow tr = t.addRow();

    for (int i = 0; i< whiArr.length; i++) {
      tr.setFloat(i, whiArr[i]);
    }

    //set the second row as whh
    // define a segunda linha como whh
    tr = t.addRow();

    for (int i = 0; i< whhArr.length; i++) {
      tr.setFloat(i, whhArr[i]);
    }

    //set the third row as woh
    // define a terceira linha como woh
    tr = t.addRow();

    for (int i = 0; i< wohArr.length; i++) {
      tr.setFloat(i, wohArr[i]);
    }

    //return table
    //Retorna a table
    return t;
  }

  //takes in table as parameter and overwrites the matricies data for this neural network
  //used to load snakes from file
  // aceita a tabela como parâmetro e sobrescreve os dados das matrizes para essa rede neural
  // usado para carregar cobras do arquivo
  void TableToNet(Table t) {

    //create arrays to tempurarily store the data for each matrix
    // cria arrays para armazenar tempora- riamente os dados para cada matriz
    float[] whiArr = new float[whi.rows * whi.cols];
    float[] whhArr = new float[whh.rows * whh.cols];
    float[] wohArr = new float[woh.rows * woh.cols];

    //set the whi array as the first row of the table
    // define o array whi como a primeira linha da tabela
    TableRow tr = t.getRow(0);

    for (int i = 0; i< whiArr.length; i++) {
      whiArr[i] = tr.getFloat(i);
    }

    //set the whh array as the second row of the table
    // define o whh array como a segunda linha da tabela
    tr = t.getRow(1);

    for (int i = 0; i< whhArr.length; i++) {
      whhArr[i] = tr.getFloat(i);
    }

    //set the woh array as the third row of the table
    // define o array woh como a terceira linha da tabela

    tr = t.getRow(2);

    for (int i = 0; i< wohArr.length; i++) {
      wohArr[i] = tr.getFloat(i);
    }

    //convert the arrays to matricies and set them as the layer matricies
    // converte os arrays em matrizes e os define como matrizes da camada
    whi.fromArray(whiArr);
    whh.fromArray(whhArr);
    woh.fromArray(wohArr);
  }
}
