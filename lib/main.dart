import 'package:f3/actors/enemy.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import 'actors/player.dart';
import 'world/ground.dart';
import 'world/obstacle.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends Forge2DGame with HasTappables {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(Vector2(1440, 780));
    Vector2 gameSize = screenToWorld(camera.viewport.effectiveSize);
    Vector2 effectiveSize = camera.viewport.effectiveSize;
    print('effective size $effectiveSize');
    print('game size $gameSize');
    print('size $size');
    add(SpriteComponent(sprite: await loadSprite('background.webp'))
      ..size = size);
    add(Ground(size));
    add(Player());
    add(Enemy(Vector2(70, -10), await loadSprite('pig.webp')));
    add(Obstacle(Vector2(70, 0), await loadSprite('barrel.png')));

    add(Obstacle(Vector2(70, 10), await loadSprite('crate.png')));
    add(Obstacle(Vector2(70, 20), await loadSprite('crate.png')));
    add(Obstacle(Vector2(70, 30), await loadSprite('crate.png')));
    add(Obstacle(Vector2(70, 40), await loadSprite('crate.png')));
    add(Obstacle(Vector2(70, 50), await loadSprite('crate.png')));
  }
}
