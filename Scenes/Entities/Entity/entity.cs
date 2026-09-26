using Godot;

public partial class Entity : Node3D
{
    public string Id { get; set; }
    public bool IsPlayerEntity { get; set; }

    public ModelingComponent ModelingComp
    {
        get => GetNodeOrNull<ModelingComponent>("Components/Modeling");
    }

    public AttackComponent AttackComp
    {
        get => GetNodeOrNull<AttackComponent>("Components/Attack");
    }

    public Node3D MovementComp
    {
        get => GetNodeOrNull<Node3D>("Components/Movment");
    }

    public Node2D CollisionComp
    {
        get => GetNodeOrNull<Node2D>("Components/Collision");
    }
}
