import "package:ember_quest/actors/water_enemy.dart";
import "package:ember_quest/managers/segment_manager.dart";
import "package:ember_quest/objects/ground_block.dart";
import "package:ember_quest/objects/platform_block.dart";
import "package:ember_quest/objects/star.dart";
import "package:ember_quest/overlays/hud.dart";
import "package:flame/game.dart";
import "package:flame/components.dart";
import "package:flutter/widgets.dart";
import 'package:flame/events.dart';

import "actors/ember.dart";

class EmberQuestGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late EmberPlayer _ember;
  double objectSpeed = 0.0;
  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;

  int starsCollected = 0;
  int health = 3;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'block.png',
      'ember.png',
      'ground.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'water_enemy.png',
    ]);

    camera.viewfinder.anchor = Anchor.topLeft;
    initializeGame(true);
  }

  void initializeGame(bool loadHud) {
    // Assume that size.x < 3200
    final segmentsToLoad = (size.x / 640).ceil();
    segmentsToLoad.clamp(0, segments.length);

    for (var i = 0; i <= segmentsToLoad; i++) {
      loadGameSegments(i, (640 * i).toDouble());
    }

    _ember = EmberPlayer(
      position: Vector2(128, canvasSize.y - 128),
    );
    add(_ember);
    if (loadHud) {
      add(Hud());
    }
  }

  void reset() {
    starsCollected = 0;
    health = 3;
    initializeGame(false);
  }

  void loadGameSegments(int segmentIndex, double xPositionOffset) {
    for (final block in segments[segmentIndex]) {
      switch (block.blockType) {
        case GroundBlock:
          add(GroundBlock(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
        case PlatformBlock:
          add(PlatformBlock(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
        case Star:
          add(Star(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
        case WaterEnemy:
          add(WaterEnemy(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
      }
    }
  }

  @override
  Color backgroundColor() => const Color.fromARGB(255, 173, 223, 247);

  @override
  void update(double dt) {
    if (health <= 0) {
      overlays.add('GameOver');
    }
    super.update(dt);
  }
}
