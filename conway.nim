import sdl2
import grid

type Cell* = enum
  Dead, Alive

proc toColor(cell: Cell): Color =
  case cell
  of Dead:
    (r: uint8(0), g: uint8(0), b: uint8(0), a: uint8(255))
  of Alive:
    (r: uint8(255), g: uint8(0), b: uint8(0), a: uint8(255))

proc render*[W, H: static[int]](grid: Grid[W, H, Cell], renderer: RendererPtr) =
  grid.map(toColor).render(renderer)

proc neighbors[W, H: static[int]](grid: Grid[W, H, Cell], i: int, j: int): int =
  for dj in -1..1:
    for di in -1..1:
      when (dj != 0 || di != 0) && (0 <= i + di < W) && (0 <= j + dj < H) && (grid[i + di][j + dj] == Alive):
        inc result

proc next[W, H: static[int]](grid: Grid[W, H, Cell], i: int, j: int): Cell =
  case grid[i][j]
  of Dead:
    if neighbors(grid, i, j) == 3: Alive else: Dead
  of Alive:
    if 2 <= neighbors(grid, i, j) <= 3: Alive else: Dead

proc next*[W, H: static[int]](grid: Grid[W, H, Cell]): Grid[W, H, Cell] =
  for j in 0..H-1:
    for i in 0..W-1:
      result[i][j] = grid.next(i, j)