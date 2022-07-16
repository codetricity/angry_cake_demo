import 'package:flame/components.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'player.dart';

class Enemy extends BodyComponent with ContactCallbacks {
  final Vector2 position;
  final Sprite sprite;
  late Sprite cloudSprite;
  late final AudioPool destroyedSfx;

  Enemy(this.position, this.sprite);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;
    add(SpriteComponent()
      ..sprite = sprite
      ..anchor = Anchor.center
      ..size = Vector2.all(4));
    cloudSprite = await gameRef.loadSprite('cloud.webp');
    destroyedSfx =
        await AudioPool.create('audio/sfx/wood_collision.mp3', maxPlayers: 4);
  }

  @override
  Body createBody() {
    final shape = PolygonShape();
    var vertices = [
      Vector2(-2, -2),
      Vector2(2, -2),
      Vector2(2, 2),
      Vector2(-2, 2)
    ];
    shape.set(vertices);
    FixtureDef fixtureDef = FixtureDef(shape, friction: 0.3);
    BodyDef bodyDef =
        BodyDef(userData: this, position: position, type: BodyType.dynamic);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Player) {
      print('hit player');
      destroyedSfx.start();
      add(SpriteComponent()
        ..sprite = cloudSprite
        ..anchor = Anchor.center
        ..size = Vector2.all(4));
      Future.delayed(
          const Duration(milliseconds: 1100), () => removeFromParent());
    }
  }
}
