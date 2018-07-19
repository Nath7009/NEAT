//Non utilisé pour le moment, sera mis en place quand je saurais quoi en faire

class Layer {
  ArrayList<Node> nodes;
  ArrayList<Connexion> connexion;
  Layer(int sizeNode, int sizeConn) {
    nodes = new ArrayList<Node>(sizeNode);
    connexion = new ArrayList<Connexion>(sizeConn);
  }
}
