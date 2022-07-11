import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Player extends BodyComponent with Tappable {
  late AudioPool launchSfx;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    launchSfx = await AudioPool.create('audio/sfx/launch.mp3', maxPlayers: 2);

    renderBody = false;
    add(SpriteComponent()
      ..sprite = await gameRef.loadSprite('red.webp')
      ..size = Vector2.all(6)
      ..anchor = Anchor.center);
  }

  @override
  Body createBody() {
    Shape shape = CircleShape()..radius = 3;
    BodyDef bodyDef = BodyDef(
        userData: this, position: Vector2(10, 5), type: BodyType.dynamic);
    FixtureDef fixtureDef = FixtureDef(shape, friction: 0.3);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    body.applyLinearImpulse(Vector2(20, -10) * 1000);
    // FlameAudio.play('sfx/launch.mp3');
    print('tapped on player');
    launchSfx.start();
    return false;
  }
}
