
from PIL import Image
import itertools
import random
import sys
import time


def grouper(n, iterable):
    args = [iter(iterable)] * n
    return itertools.izip_longest(fillvalue=(0, 0, 0), *args)


def random_color():
    return tuple(random.randrange(256) for _ in xrange(3))


def make_chunk(size):
    return tuple(random_color() for _ in xrange(size))


def permute_chunks(image, chunk_size):
    code_book, used_values, modified = {}, set(), []
    for chunk in grouper(chunk_size, image.getdata()):
        try:
            modified_chunk = code_book[chunk]
        except KeyError:
            modified_chunk = make_chunk(chunk_size)
            while modified_chunk in used_values:
                modified_chunk = make_chunk(chunk_size)
            code_book[chunk] = modified_chunk
            used_values.add(modified_chunk)
        modified.extend(modified_chunk)
    output = Image.new("RGB", image.size)
    pixels = image.size[0] * image.size[1]
    output.putdata(modified[:pixels])
    return output


if __name__ == "__main__":
    input_filename = sys.argv[1]
    infile = Image.open(input_filename)

    time.clock()
    for chunk_size in map(int, sys.argv[2:]):
        print "Doing chunk size {}".format(chunk_size)
        filename = "{}_{}.png".format(input_filename, chunk_size)
        permute_chunks(infile, chunk_size).save(filename)
        print "Done in {}".format(time.clock())

    print "Printing noisy image"
    noisy_image = Image.new("RGB", infile.size)
    pixels = infile.size[0] * infile.size[1]
    print "Pixels: {}".format(pixels)
    noisy_data = [random_color() for _ in xrange(pixels)]
    noisy_image.putdata(noisy_data)
    noisy_image.save("{}_random.png".format(input_filename))
    print "Done in {}".format(time.clock())
