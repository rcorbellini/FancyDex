# The FancyDex
## Main Goal


Make a pokedex App in Flutter, with [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) + [TDD](https://resocoder.com/flutter-clean-architecture-tdd/),  using [Bloc Pattern](https://www.youtube.com/watch?v=PLHln7wHgPE) exploring the magical Lib [Fancy Streams](https://github.com/rcorbellini/FancyStreams) to exterminate some boilerplates of usage of streams.
Also load the [data of pokemon](https://pokeapi.co/) by network or cache using repository pattern.

Layout inspired on [Pokedex By Bruna Campos](https://dribbble.com/shots/14241781-Pok-dex).


## The Result
- [x] TDD (almost reach).
- [x] Clean Architeture by Uncle bob.
- [x] Bloc Pattern.
- [x] Fancy Streams.


![screens_fancy](https://user-images.githubusercontent.com/151217/107714940-f1b0c280-6cac-11eb-9bb0-9cfa00d0a5b7.png)
<p align="center">
<img src="https://media.giphy.com/media/vdIY35CdQ123Yccn0D/giphy.gif" align="center" width="216"  height="480" />
</p>


## Architecture
![architeture](https://user-images.githubusercontent.com/151217/107596502-a6d47380-6bf6-11eb-8adc-2591c9fd538b.jpg)

## Screens interactions
### Home
![home_event_state](https://user-images.githubusercontent.com/151217/107593763-e72ff380-6bee-11eb-9d64-292e5fb1da56.jpg)

### Detail
![detail_event_state](https://user-images.githubusercontent.com/151217/107593760-e4cd9980-6bee-11eb-9aff-15f71a8b8a3d.jpg)

 

## The Todo List
- [ ] Object (Blocs) Must Be Injected by some DI.
- [ ] Button to relad when erro happen.
- [ ] Create a definitive Launch Icon.
- [ ] Refactory and add some better Docs.
