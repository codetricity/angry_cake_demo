import 'package:flame_forge2d/flame_forge2d.dart';

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
