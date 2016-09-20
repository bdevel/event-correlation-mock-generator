# Ruby Multi-Agent System Simulation 
This library is used to create agent based models that simulate the
real world. It may be used to simulate human, machine, or natural
behaviour with one or more agents interaction with each other in an
environment. The library supports logging of events for later analysis.

See `demos/daily.rb` to see basic syntax for creating a simulation.


# Object Layout
The object model tries to follow the termonology of a play at the
theater to help with devloper cognition.

## Theater
The `Theater` should be thought of as the World. It is where you pay put
properties or methods that are global to your application but not
nessisarily specific one type of simulation. It will control the
`current_time`, has a `Transcript`, and a `Stage` which hosts the `Actors`.

## Stage
The `Stage` is the environment where the the `Actors` perform. 
Properties of the stage should be things that effects all actors and
all actors can be aware of. You may extend `Stage` to create your own
envirnment that implements, for example, a grid system.

## Actors
`Actors` are agents who perform on your stage. 

## Roles
A `Role` is a collection of `Behaviors` that is an `Actor` will
fulfill. A role may be `Human` or `WebServer` or the actions that are
taken are based on the role's `Behaviors`.

## Behaviors
A `Behavior` specifies what actions an `Actor` will take either at a
specific time or when a prior event triggers an action.

## Events
Events are 

### Triggered Events
A `TriggeredEvent` is an action that will happened under some
circumstance actor is placed. 

### Timed Event
A `TimedEvent` is an action that will happen at some point in the
future. 

## Scripts
This is a file that sets up the `Theater`, `Stage`, and `Actors` for
the simulation.

## Transcript
A log of events that happened during the simulation.



<!--
# Verification and Validation
Verification involves the model being debugged to ensure it works
correctly, whereas validation ensures that the right model has been
built. Best to verify during execution. Make sure certain things don't
or do happen. The `Critic`.
-->
