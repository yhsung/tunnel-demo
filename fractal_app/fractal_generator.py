import math
import random
import numpy as np
import matplotlib.pyplot as plt


def draw_mandelbrot(max_iter: int = 50) -> None:
    """Render the Mandelbrot set."""
    width, height = 800, 800
    real = np.linspace(-2.0, 1.0, width)
    imag = np.linspace(-1.5, 1.5, height)
    c = real[np.newaxis, :] + 1j * imag[:, np.newaxis]
    z = np.zeros_like(c)
    div_time = np.zeros(z.shape, dtype=int)

    for i in range(max_iter):
        mask = np.abs(z) <= 2
        z[mask] = z[mask] ** 2 + c[mask]
        div_time[mask] = i

    plt.imshow(div_time, extent=(-2, 1, -1.5, 1.5), cmap="magma")
    plt.title("Mandelbrot Set")
    plt.xlabel("Re")
    plt.ylabel("Im")
    plt.show()


def draw_sierpinski(iterations: int = 5000) -> None:
    """Render the Sierpinski triangle using the chaos game."""
    vertices = np.array([
        [0.0, 0.0],
        [1.0, 0.0],
        [0.5, math.sqrt(3) / 2],
    ])
    point = np.array([0.0, 0.0])
    points = []
    for _ in range(iterations):
        vertex = random.choice(vertices)
        point = (point + vertex) / 2
        points.append(point.copy())

    xs, ys = zip(*points)
    plt.scatter(xs, ys, s=0.2, color="black")
    plt.axis("equal")
    plt.axis("off")
    plt.title("Sierpinski Triangle")
    plt.show()


def main() -> None:
    print("Select a fractal to generate:")
    print("1. Mandelbrot Set")
    print("2. Sierpinski Triangle")
    choice = input("Enter choice (1/2): ").strip()
    if choice == "1":
        draw_mandelbrot()
    elif choice == "2":
        draw_sierpinski()
    else:
        print("Invalid choice")


if __name__ == "__main__":
    main()
