//Criando a classe da matriz
class Matrix {
  
  //local variables
  //Atributos da matriz do jogo
  int rows; //Linha
  int cols; //Coluna
  float[][] matrix; //Matrix
  
  //constructor
  //Construtor
  Matrix(int r, int c) {
    rows = r;
    cols = c;
    matrix = new float[rows][cols];
  }
  
  //constructior from 2D array
  //construtor da matriz 2D
  Matrix(float[][] m) {
    matrix = m;
    cols = m.length;
    rows = m[0].length;
  }
  
  //print matrix
  //Imprimir a matriz
  void output() {
    for (int i =0; i<rows; i++) {
      for (int j = 0; j<cols; j++) {
        print(matrix[i][j] + "  ");
      }
      println(" ");
    }
    println();
  }
  
  //multiply by scalor
  //multiplique por scalor
  void multiply(float n ) {
    for (int i =0; i<rows; i++) {
      for (int j = 0; j<cols; j++) {
        matrix[i][j] *= n;
      }
    }
  }

  //return a matrix which is this matrix dot product parameter matrix
  //retorna uma matriz que é essa matriz de parâmetro de produto de ponto de matriz
  Matrix dot(Matrix n) {
    
    //Criando a matrix resultado
    Matrix result = new Matrix(rows, n.cols);
   
   //Coluna igual a numero de linhas
    if (cols == n.rows) {
      //for each spot in the new matrix
      //para cada ponto na nova matriz
      for (int i =0; i<rows; i++) {
        for (int j = 0; j<n.cols; j++) {
          float sum = 0;
          for (int k = 0; k<cols; k++) {
            sum+= matrix[i][k]*n.matrix[k][j];
          }
          result.matrix[i][j] = sum;
        }
      }
    }

    return result;
  }

  //set the matrix to random ints between -1 and 1
  //definir a matriz para ints aleatórios entre -1 e 1
  void randomize() {
    for (int i =0; i<rows; i++) {
      for (int j = 0; j<cols; j++) {
        matrix[i][j] = random(-1, 1);
      }
    }
  }

  //add a scalor to the matrix
  //Adicione um escalador a matriz
  void Add(float n ) {
    for (int i =0; i<rows; i++) {
      for (int j = 0; j<cols; j++) {
        matrix[i][j] += n;
      }
    }
  }

  //return a matrix which is this matrix + parameter matrix
  //retorna uma matriz que é essa matriz + matriz de parâmetros
  Matrix add(Matrix n ) {
    Matrix newMatrix = new Matrix(rows, cols);
    if (cols == n.cols && rows == n.rows) {
      for (int i =0; i<rows; i++) {
        for (int j = 0; j<cols; j++) {
          newMatrix.matrix[i][j] = matrix[i][j] + n.matrix[i][j];
        }
      }
    }
    return newMatrix;
  }

  //return a matrix which is this matrix - parameter matrix
  //retorna uma matriz que é essa matriz - matriz de parâmetros
  Matrix subtract(Matrix n ) {
    Matrix newMatrix = new Matrix(cols, rows);
    if (cols == n.cols && rows == n.rows) {
      for (int i =0; i<rows; i++) {
        for (int j = 0; j<cols; j++) {
          newMatrix.matrix[i][j] = matrix[i][j] - n.matrix[i][j];
        }
      }
    }
    return newMatrix;
  }

  //return a matrix which is this matrix * parameter matrix (element wise multiplication)
  //retorna uma matriz que é essa matriz de parâmetros * matriz (multiplicação por elementos)
  Matrix multiply(Matrix n ) {
    Matrix newMatrix = new Matrix(rows, cols);
    if (cols == n.cols && rows == n.rows) {
      for (int i =0; i<rows; i++) {
        for (int j = 0; j<cols; j++) {
          newMatrix.matrix[i][j] = matrix[i][j] * n.matrix[i][j];
        }
      }
    }
    return newMatrix;
  }

  //return a matrix which is the transpose of this matrix
  //retorna uma matriz que é a transposta dessa matriz
  Matrix transpose() {
    Matrix n = new Matrix(cols, rows);
    for (int i =0; i<rows; i++) {
      for (int j = 0; j<cols; j++) {
        n.matrix[j][i] = matrix[i][j];
      }
    }
    return n;
  }

  //Creates a single column array from the parameter array
  //Cria uma matriz de coluna única a partir do array de parâmetros
  Matrix singleColumnMatrixFromArray(float[] arr) {
    Matrix n = new Matrix(arr.length, 1);
    for (int i = 0; i< arr.length; i++) {
      n.matrix[i][0] = arr[i];
    }
    return n;
  }
  
  //sets this matrix from an array
  //define esta matriz a partir de um array
  void fromArray(float[] arr) {
    for (int i = 0; i< rows; i++) {
      for (int j = 0; j< cols; j++) {
        matrix[i][j] =  arr[j+i*cols];
      }
    }
  }
  
  //returns an array which represents this matrix
  //retorna uma matriz que representa essa matriz
  float[] toArray() {
    float[] arr = new float[rows*cols];
    for (int i = 0; i< rows; i++) {
      for (int j = 0; j< cols; j++) {
        arr[j+i*cols] = matrix[i][j];
      }
    }
    return arr;
  }


  //for ix1 matrixes adds one to the bottom
  //para matrizes ix1 adiciona uma na parte inferior
  Matrix addBias() {
    Matrix n = new Matrix(rows+1, 1);
    for (int i =0; i<rows; i++) {
      n.matrix[i][0] = matrix[i][0];
    }
    n.matrix[rows][0] = 1;
    return n;
  }

  //applies the activation function(sigmoid) to each element of the matrix
  //aplica a função de ativação (sigmoid) a cada elemento da matriz
  Matrix activate() {
    Matrix n = new Matrix(rows, cols);
    for (int i =0; i<rows; i++) {
      for (int j = 0; j<cols; j++) {
        n.matrix[i][j] = sigmoid(matrix[i][j]);
      }
    }
    return n;
  }
  
  //sigmoid activation function
  //função de ativação sigmoide
  float sigmoid(float x) {
    float y = 1 / (1 + pow((float)Math.E, -x));
    return y;
  }
  //returns the matrix that is the derived sigmoid function of the current matrix
  //retorna a matriz que é a função sigmóide derivada da matriz atual
  Matrix sigmoidDerived() {
    Matrix n = new Matrix(rows, cols);
    for (int i =0; i<rows; i++) {
      for (int j = 0; j<cols; j++) {
        n.matrix[i][j] = (matrix[i][j] * (1- matrix[i][j]));
      }
    }
    return n;
  }

  //returns the matrix which is this matrix with the bottom layer removed
  //retorna a matriz que é essa matriz com a camada inferior removida
  Matrix removeBottomLayer() {
    Matrix n = new Matrix(rows-1, cols);      
    for (int i =0; i<n.rows; i++) {
      for (int j = 0; j<cols; j++) {
        n.matrix[i][j] = matrix[i][j];
      }
    }
    return n;
  }

  //Mutation function for genetic algorithm
  //Função de mutação para algoritmo genético
  void mutate(float mutationRate) {
    
    //for each element in the matrix
    //para cada elemento na matriz
    //Linhas
    for (int i =0; i<rows; i++) {
      //Colunas
      for (int j = 0; j<cols; j++) {
        //Criando um valor ramdomico de valor maximo 1
        float rand = random(1);
        //if chosen to be mutated
        //se escolhido para ser mutado
        if (rand<mutationRate) {
          //add a random value to it(can be negative)
          //adiciona um valor aleatório a ele (pode ser negativo)
          matrix[i][j] += randomGaussian()/5;
          
          //set the boundaries to 1 and -1
          //defina os limites para 1 e -1
          if (matrix[i][j]>1) {
            //Atribuindo valor a posica da matriz
            matrix[i][j] = 1;
          }
          if (matrix[i][j] <-1) {
            //Atribuindo valor a posicao da matriz
            matrix[i][j] = -1;
          }
        }
      }
    }
  }

  //Crossover matrix
  //returns a matrix which has a random number of vaules from this matrix and the rest from the parameter matrix
  //retorna uma matriz que tem um número aleatório de values dessa matriz e o restante da matriz de parâmetros
  Matrix crossover(Matrix partner) {
    
    //Criando uma matriz crianca
    Matrix child = new Matrix(rows, cols);
    
    //pick a random point in the matrix
    // escolhe um ponto aleatório na matriz
    int randC = floor(random(cols)); //Rand colunas
    int randR = floor(random(rows)); //Rand Linhas
    //Linha
    for (int i =0; i<rows; i++) {
      //Coluna
      for (int j = 0; j<cols; j++) {
        //if before the random point then copy from this matric
        //se antes do ponto aleatório, copie dessa matriz
        if ((i< randR)|| (i==randR && j<=randC)) {
          //Matriz crianca e igual a matrix original
          child.matrix[i][j] = matrix[i][j];
        
        //if after the random point then copy from the parameter array
        // se depois do ponto aleatório, copie da matriz de parâmetros          
        } else { 
          //Crianca gerada a partir dos pais
          child.matrix[i][j] = partner.matrix[i][j];
        }
      }
    }
    
    //Retorna o filho
    return child;
  }

  //return a copy of this matrix
  //retorna uma cópia desta matriz
  Matrix clone() {
    //Criando um objeto matrix com a classe matrix
    Matrix clone = new Matrix(rows, cols);
    //For para as linhas
    for (int i =0; i<rows; i++) {
      //For para as colunas
      for (int j = 0; j<cols; j++) {
        //Clone da matrix
        clone.matrix[i][j] = matrix[i][j];
      }
    }
    
    //Retorna o clone
    return clone;
  }
}
