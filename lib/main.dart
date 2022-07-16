import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.setLandscape();
  Flame.device.fullScreen();
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends Forge2DGame with HasTappables {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(Vector2(1400, 780));

    add(
      SpriteComponent(sprite: await loadSprite('background.webp'), size: size),
    );
    add(Ground(size));
    add(Player());
    add(Obstacle(Vector2(80, -10), await loadSprite('pig.webp')));
    add(Obstacle(Vector2(80, 0), await loadSprite('barrel.png')));

    add(Obstacle(Vector2(80, 10), await loadSprite('crate.png')));
    add(Obstacle(Vector2(80, 20), await loadSprite('crate.png')));
    add(Obstacle(Vector2(80, 30), await loadSprite('crate.png')));
    add(Obstacle(Vector2(80, 40), await loadSprite('crate.png')));
    add(Obstacle(Vector2(80, 50), await loadSprite('crate.png')));
  }
}

class Player extends BodyComponent with Tappable {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;
    add(SpriteComponent()
      ..sprite = await gameRef.loadSprite('red.webp')
      ..size = Vector2.all(6)
      ..anchor = Anchor.center);
  }

  @override
  Body createBody() {
    Shape shape = CircleShape()..radius = 3;
    BodyDef bodyDef = BodyDef(position: Vector2(10, 5), type: BodyType.dynamic);
    FixtureDef fixtureDef = FixtureDef(shape, friction: 0.3);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    body.applyLinearImpulse(Vector2(20, -10) * 1000);
    return false;
  }
}

class Ground extends BodyComponent {
  final Vector2 gameSize;

  Ground(this.gameSize) : super(renderBody: false);

  @override
  Body createBody() {
    Shape shape = EdgeShape()
      ..set(
          Vector2(0, gameSize.y * .86), Vector2(gameSize.x, gameSize.y * .86));
    BodyDef bodyDef = BodyDef(userData: this, position: Vector2.zero());
    final fixtureDef = FixtureDef(shape, friction: 0.3);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class Obstacle extends BodyComponent {
  final Vector2 position;
  final Sprite sprite;

  Obstacle(this.position, this.sprite);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;
    add(SpriteComponent()
      ..sprite = sprite
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
}
