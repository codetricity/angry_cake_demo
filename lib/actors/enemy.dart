import 'package:f3/actors/player.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Enemy extends BodyComponent with ContactCallbacks {
  final Vector2 position;
  Sprite enemySprite;
  late final AudioPool destroyedSfx;
  late Sprite destroyedSprite;

  Enemy(this.position, this.enemySprite);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;
    destroyedSfx =
        await AudioPool.create('audio/sfx/destroyed.mp3', maxPlayers: 1);
    destroyedSprite = await gameRef.loadSprite('cloud.webp');
    add(SpriteComponent()
      ..sprite = enemySprite
      ..anchor = Anchor.center
      ..size = Vector2.all(4));
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
    // print('contact');
    // print(other);
    // if (other is Obstacle) {
    //   print('hit Obstacle');
    // }
    if (other is Player) {
      print('hit');
      destroyedSfx.start();
      add(SpriteComponent()
        ..sprite = destroyedSprite
        ..anchor = Anchor.center
        ..size = Vector2.all(4));
      Future.delayed(
          const Duration(milliseconds: 1100), () => removeFromParent());
    }
  }
}
