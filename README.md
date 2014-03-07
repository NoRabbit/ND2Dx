ND2Dx
=====

2D GPU Accelerated Game Engine for Flash Stage3D

This a big revision of the original ND2D by Lars Gerckens.

It is a very early version of ND2Dx, there will be many changes and a couple of things still need to be rethought but I'm already using it in production.

The main changes & concepts of ND2Dx:
* A node (Node2D) doesn't render anything anymore, use instead Mesh2DRendererComponent component.
* Component system: add functionalities via components by attaching them to any Node2D (more flexible, increase re-usability and structure of code).
* Mesh2DRendererComponent: component that is necessary for rendering a mesh on screen (it takes a material and a mesh).
* Mesh2D: object that holds the vertex data (separated from everything, can be reused and/or easily modified).
* Materials: holds the shaders data and is responsible for rendering (except for batching) (can be extended to hold other kind of data like a Texture2D).
* Unified Textures: Texture2D is still a texture but can also be an atlas.
* Use of a RenderSupport object for rendering (allows for more flexible and simplified batchings techniques).
* Finite State Machine: structure logic into states composed of actions (increase structured code, flexibility and re-usability).
* Simplified creation of Atlas and animated textures.

Visit: blog.open-design.be for tutorials (Jelly Smash: how to make a game with ND2Dx) and benchmarks (also present in this git)
