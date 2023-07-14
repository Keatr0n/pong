import 'package:pong/models/game_object.dart';
import 'package:pong/models/hitbox.dart';

class GameState {
  GameState(this.gameObjects, this.gameBounds);

  final Hitbox gameBounds;

  final List<GameObject> gameObjects;

  bool isOutOfBounds(GameObject gameObject) {
    return gameObject.calculateHitbox().collidesWith(gameBounds);
  }

  List<GameObject> getCollisions(GameObject gameObject) {
    final hitbox = gameObject.calculateHitbox();
    return gameObjects.where((other) {
      if (other == gameObject) return false;
      return other.calculateHitbox().collidesWith(hitbox);
    }).toList();
  }

  void destroy() {
    for (final gameObject in gameObjects) {
      gameObject.destroy();
    }
  }

  void init() {
    for (final gameObject in gameObjects) {
      gameObject.init(this);
    }
  }

  void update() {
    for (final gameObject in gameObjects) {
      gameObject.update(this);
    }
  }
}
