class Node {
  int ID;
  int type; //0=input, 1=hidden, 2=output
  int layer; //The depth at which is the node
  float x,y;
  float bias, sum, output;
  
  Node(int ID, int type) {
    this.ID = ID;
    this.type = type;
    this.bias = random(-1,1);
  }
  
  float[] serealize(){
    float[] nb = new float[]{ID,type};
    return nb;
  }
  
  void activate(){
    this.output = activation(sum + bias);
  }
}

class Connexion {
  int input, output, innovation;
  float weight;
  boolean enabled;
  
  Connexion(int input, int output, int innovation, float weight, boolean enabled) {
    this.input = input; //ID of the input node
    this.output = output; //ID of the output node
    this.innovation = innovation; //Epoque of the connexion
    this.weight = weight; //Weight to multiply
    this.enabled = enabled; //Determines if the connexion is active
  }
  
  float[] serealize(){
    int enable = enabled ? 1 : 0;
    float[] nb = new float[]{input,output,weight,enable};
    return nb;
  }
}

float activation(float x){
  return 1/(1+exp(-x));
}
