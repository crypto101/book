Ignore this PR, it is a test to see if I can do this thing I want to do entirely inside GitHub.

Appendices
==========

.. raw:: latex

   \appendix

.. _modular-arithmetic:

Modular arithmetic
------------------

Modular arithmetic is used for many public key cryptosystems, including
:term:`public-key encryption` algorithms like RSA and key exchange protocols
like Diffie-Hellman.

Modular arithmetic is something most people actually already understand,
they just don't know it's called that. We can illustrate the principles
of modular arithmetic using a clock.

.. figure:: ./Illustrations/ModularArithmetic/Clock2.svg
   :align: center

   A clock, pointing to 2.

For simplicity's sake, our demonstration 12-hour clock only shows hours,
not minutes or seconds. Also unlike real clocks, the hour hand is never
halfway in between two hours: it always shows an exact hour, such as 2
or 9.

.. _Modular subtraction:
.. _Modular addition:

Addition and subtraction
~~~~~~~~~~~~~~~~~~~~~~~~

It obviously makes sense to add hours on our clock: if it's 2 o'clock
now, and you'd like to know what time it is five hours from now, you can
add 5, and end up with 7, as you can see in :numref:`fig-Clock2Plus5`.

.. _fig-Clock2Plus5:

.. figure:: ./Illustrations/ModularArithmetic/Clock2Plus5.svg
   :align: center

   :math:`2 + 5 = 7`, on the clock.

Similarly, we can subtract times. If it's 10 o'clock now, and you'd like
to know what time it was two hours ago, you subtract 2 and end up with
8.


.. _fig-ClockMinus:

.. figure:: ./Illustrations/ModularArithmetic/Clock10Minus2.svg
   :align: center

   :math:`10 - 2 = 8`, on the clock.

The “weird” part is when you cross the boundary at 12. As far as the
clock is concerned, there's no real difference between 12 and 0. If it's
10 o'clock now, it'll be 2 o'clock in four hours. If it's 2 o'clock now,
it was 9 o'clock five hours ago.

This is an example of what's called “modular arithmetic”. The modulus,
in this case, is 12. We can write the above equations as:

.. math::

   (10 + 4) \bmod{12} = 2

.. math::

   (2 - 5) \bmod{12} = 9

In these equations, the :math:`\bmod` is an operator, giving the
remainder after division. When we are dealing with modular arithmetic,
where all operations are affected by the modulus instead of a simple
single operation, we'll instead write :math:`\negthickspace\pmod{12}` at
the end of the equation and use an :math:`\equiv` sign instead of an
equals sign (:math:`=`):

.. math::

   10 + 4 \equiv 2 \pmod{12}

.. math::

   2 - 5 \equiv 9 \pmod{12}

This is read as “ten plus four is equivalent to two, modulo twelve” and
“two minus five is equivalent to nine, modulo twelve”. That might seem
like a trivial notational hack now, but the difference will become
apparent once we start applying tricks for doing more complex modular
computations, like multiplication and exponentiation.

In general, we call two numbers *equivalent modulo some modulus* if
dividing them by the modulus leaves the same remainder. We can
illustrate this with our previous examples: :math:`10 + 4 = 14` leaves a
remainder of 2 when divided by 12, so it is equivalent to 2 modulo 12.
For negative numbers, we'll always use positive remainders. For example,
:math:`2 - 5 \equiv 9 \pmod{12}`. This is exactly the way a clock works
as well: if it's 2 o'clock now, then five hours ago was “nine o'clock”,
not “minus three o'clock”.

Prime numbers
~~~~~~~~~~~~~

Prime numbers are wonderful kinds of numbers that come back in many
branches of mathematics. Anything I say about them probably won't do
them justice; but we're in a practical book about applied cryptography,
so we'll only see a few properties.

A prime number is a number that is divisible only by two numbers: 1 and
itself. For example, 3 is a prime number, but 4 is not, because it can
be divided by 2.

Any number can be written as a product of prime factors: a bunch of
prime numbers multiplied together. That product is called a prime
factorization. For example, 30 can be factorized into 2, 3 and 5:

.. math::

   30 = 2 \cdot 3 \cdot 5

Sometimes, a prime number will occur more than once in a factorization.
For example, the factorization of 360 has 2 in it three times, and three
in it twice:

.. math::

   360 = 2^3 \cdot 3^2 \cdot 5

The factorization of any prime number is just that prime number itself.

Modern mathematics no longer considers 1 to be a prime number, even
though it is only divisible by 1 and itself (1 again). Under this
convention, every number not only *has* a factorization, but that
factorization is *unique*. Otherwise, 4 could be factored not only as
:math:`2 \cdot 2`, but also as :math:`2 \cdot 2 \cdot 1`,
:math:`2 \cdot 2 \cdot 1 \cdot 1`, and so on. The uniqueness of factorization helps in some important
proofs in number theory.

Also, 0 is *not* a prime number, as it is divisible by many numbers: all
numbers except 0 itself.

Two numbers are called coprime when their greatest common divisor is 1,
or, to put it in another way, they don't share any prime factors. Since
the only prime factor a prime has is itself, that means that all prime
numbers are also coprime. More generally, a prime is coprime to any
number that isn't a multiple of that prime.

Multiplication
~~~~~~~~~~~~~~

You might remember you were first taught multiplication as repeated
addition:

.. math::

   n \cdot x = \underbrace{x + x + \ldots + x}_{n \text{ times}}

Modular multiplication is no different. You can compute modular
multiplication by adding the numbers together, and taking the modulus
whenever the sum gets larger than the modulus. You can also just do
regular multiplication, and then take the modulus at the end.

Division and modular inverses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Division is defined as the inverse of multiplication. So,
:math:`a \cdot b \equiv c \pmod m`, then
:math:`\frac{c}{b} \equiv a \pmod m`.

For example, :math:`5 \cdot 6 \equiv 2 \pmod 7`; so:
:math:`\frac{2}{6} \equiv 5 \pmod 7`. This is because
:math:`5 \cdot 6 = 30`, which leaves a remainder of 2 when divided by 7.

Usually, instead of using division directly, we'll multiply using
something called a modular inverse. The modular inverse of :math:`a` is
a number, that when you multiply it with :math:`a`, you get 1. This is
just like the inverse of a number in regular arithmetic:
:math:`x \cdot \frac{1}{x} = 1`.

Like in regular arithmetic, not all numbers have modular inverses. This
is the equivalent of dividing by zero in regular arithmetic.

There are two algorithms that are used to compute modular inverses: the
extended Euclidean algorithm, and with the help of Euler's theorem.

The extended Euclidean theorem
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

TODO: explain, and how you can get modular inverses with it

Using Euler's theorem
^^^^^^^^^^^^^^^^^^^^^

Euler's theorem states that if two numbers :math:`a` and :math:`n` are
coprime, then:

.. math::

   a^{\phi(n)} \equiv 1 \pmod n

In that equation, :math:`\phi` is Euler's totient function, which counts
the amount of numbers that are coprime to (and less than or equal to)
its argument. As an example, the totient of 10 is 4, as 1, 3, 7, and 9
do not have common prime factors with 10.

We can use Euler's theorem to find the multiplicative inverse of
:math:`a`. If we just multiply both sides of the equation by
:math:`a^{-1}`, we get:

.. math::

   a^{\phi(n) - 1} \equiv a^{-1} \pmod n

That gives us a direct formula for computing :math:`a^{-1}`.
Unfortunately, this is still generally less interesting than using the
extended Euclidean algorithm, for two reasons:

#. It requires computing the totient function, which is harder than
   running the extended Euclidean algorithm in the first place, unless
   you happen to know the prime factors of :math:`n`.
#. Modular exponentiation is computationally expensive.

One exception to that rule is for prime moduli. Since a prime is coprime
to every other number, and since there are :math:`p - 1` numbers smaller
than :math:`p`, :math:`\phi(p) = p - 1`. So, for a prime modulus, the
modular inverse of :math:`a` is simply:

.. math::

   a^{-1} \equiv a^{\phi(p) - 1} \equiv a^{p - 2} \pmod p

This still requires us to be able to efficiently raise :math:`a` to a
power using modular arithmetic. We'll discuss how you can do that
efficiently in the next section.

Exponentiation
~~~~~~~~~~~~~~

Like multiplication is taught as repeated addition, exponentiation can
be thought of as repeated multiplication:

.. math::

   a^n = \underbrace{a \cdot a \cdot \ldots \cdot a}_{n \text{ times}}

As with multiplication, it's possible to compute modular exponentiation
by performing regular exponentiation, and then taking the modulus at the
end. However, this is very inefficient, particularly for large
:math:`n`: the product quickly becomes far too large.

Fortunately, it is possible to compute modular exponentiation much more
efficiently. This is done by splitting the problem up into smaller
sub-problems. For example, instead of computing :math:`2^{20}` directly
you could split it up:

.. math::

   2^{20} = (2^{10})^2

:math:`2^{10}` is something you can compute on your hands: start at 2,
which is :math:`2^1`, and then keep multiplying by two. Every time you
multiply by two, the exponent goes up by 1, so by the time you've
counted all your fingers (assuming you have ten of them), you're done.
The result is 1024. So:

.. math::

   \begin{aligned}
   2^{20} &\equiv (2^{10} \bmod {15})^2 \pmod {15} \\
          &\equiv (1024 \bmod {15})^2   \pmod {15} \\
          &\equiv 4^2                   \pmod {15} \\
          &\equiv 16                    \pmod {15} \\
          &\equiv 1                     \pmod {15}
   \end{aligned}

Exponentiation by squaring
~~~~~~~~~~~~~~~~~~~~~~~~~~

A particularly efficient way to do it on computers is splitting the
exponent up into a sum of powers of two. This is called exponentiation
by squaring, or sometimes also binary exponentiation. Suppose we want to
compute :math:`3^{209} \pmod {19}`. First, we split up 209 into a sum of
powers of two. This process is essentially just writing 209 down in
binary: ``0b11010001``. That's very practical if the computation is
being performed by a computer, because that's typically how the computer
had the number stored in the first place.

.. math::

   \arraycolsep=1pt
   \begin{array}{lllllllll}
   209 &= 1 \cdot 2^{7} &+ 1 \cdot 2^{6} &+ 0 \cdot 2^{5} &+ 1 \cdot 2^{4} &+ 0 \cdot 2^{3} &+ 0 \cdot 2^{2} &+ 0 \cdot 2^{1} &+ 1 \cdot 2^{0} \\
       &= 1 \cdot 128   &+ 1 \cdot 64    &+ 0 \cdot 32    &+ 1 \cdot 16    &+ 0 \cdot 8     &+ 0 \cdot 4     &+ 0 \cdot 2     &+ 1 \cdot 1 \\
       &= 128           &+ 64            &                &+ 16            &                &                &                &+ 1
   \end{array}

We use that expansion into a sum of powers of two to rewrite the
equation:

.. math::

   \begin{aligned}
   3^{209} &= 3^{128 + 64 + 16 + 1} \\
           &= 3^{128} \cdot 3^{64} \cdot 3^{16} \cdot 3^1
   \end{aligned}

Now, we need to compute those individual powers of 3: 1, 16, 64 and 128.
A nice property of this algorithm is that we don't actually have to
compute the big powers separately from scratch. We can use previously
computed smaller powers to compute the larger ones. For example, we need
both :math:`3^{128} \pmod {19}` and :math:`3^{64} \pmod {19}`, but you
can write the former in terms of the latter:

.. math::

   3^{128} \bmod {19} = (3^{64} \bmod {19})^2 \pmod {19}

Let's compute all the powers of 3 we need. For sake of brevity, we won't
write these out entirely, but remember that all tricks we've already
seen to compute these still apply:

.. math::

   \begin{aligned}
   3^{16}  &\equiv 17                               \pmod {19} \\
   3^{64}  &\equiv (3^{16})^4 \equiv 17^4 \equiv 16 \pmod {19} \\
   3^{128} &\equiv (3^{64})^2 \equiv 16^2 \equiv 9  \pmod {19}
   \end{aligned}

Filling these back in to our old equation:

.. math::

   \begin{aligned}
   3^{209} &=      3^{128} \cdot 3^{64} \cdot 3^{16} \cdot 3^1 \pmod {19} \\
           &\equiv 9       \cdot 16     \cdot 17     \cdot 3   \pmod {19}
   \end{aligned}

This trick is particularly interesting when the exponent is a very large
number. That is the case in many cryptographic applications. For
example, in RSA decryption, the exponent is the private key :math:`d`,
which is usually more than a thousand bits long. Keep in mind that this
method will still leak timing information, so it's only suitable for
offline computation. Modular exponentiation can also be computed using a
technique called a Montgomery ladder, which we'll see in the next
section.

Many programming languages provide access to specific modular
exponentiation functions. For example, in Python, ``pow(e, x, m)``
performs efficient modular exponentiation. However, the expression
``(e ** x) % m`` will still use the inefficient method.

Montgomery ladder exponentiation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

As we mentioned before, the exponentiation by squaring algorithm is
simple and fast, but the time it takes to complete depends on the value
of the exponent. That's bad, because the exponent is usually a secret
value, such as a Diffie-Hellman secret or the private exponent :math:`d`
in RSA.

The Montgomery ladder is an algorithm that resolves this by guaranteeing
the same number of operations irrespective of the particular value of
the exponent. It was originally applied for efficient scalar
multiplications over elliptic curves, but the mathematics works for many
other systems: specifically, for any abelian group.
:cite:`montgomerypowerladder`

Deriving the ladder
^^^^^^^^^^^^^^^^^^^

.. canned_admonition::
   :from_template: advanced

   This section involves a good deal of arithmetic tricks. You might want to get
   out some paper and pencil to follow along.


Like with exponentiation by squaring, we start by looking at the binary
expansion of the exponent :math:`k`. Generally, any :math:`k` can be
written as a sum (:math:`\sum`) of some powers of two (:math:`2^i`). If
:math:`2^j` appears in the binary expansion, we'll say that
:math:`k_j = 1`; if it doesn't, we'll say that :math:`k_j = 0`. That
gives us:

.. math::

   k = \sum_{i=0}^{t-1} 2^i k_i

That definition might look scary, but all you're really doing here is
defining :math:`k_i` as bit of :math:`k` at position :math:`i`. The sum
goes over all the bits: if :math:`k` is :math:`t` bits long, and we
start indexing at 0, the index of the highest bit is :math:`t - 1`, and
the index of the lowest bit is 0. For example, the binary expansion of
the number 6 is ``0b110``. That number is three bits long, so
:math:`t = 3`. So:

.. math::

   \begin{aligned}
   6 &= \sum_{i = 0}^{t - 1} 2^i k_i \\
     &= \sum_{i = 0}^{2} 2^i k_i \\
     &= k_2 \cdot 2^2 + k_1 \cdot 2^1 + k_0 \cdot 2^0 \\
     &= 1 \cdot 2^2 + 1 \cdot 2^1 + 0 \cdot 2^0
   \end{aligned}

So, :math:`(k_2, k_1, k_0) = (1, 1, 0)`.

The next few steps don't make a lot of sense until you see them come
together at the end, so bear with me and check that the math works out.
We'll define a related sum, :math:`L_j`:

.. math::

   L_j = \sum_{i = j}^{t - 1} 2^{i - j} k_i

For example, :math:`L_1` (still with :math:`k = 6`) becomes:

.. math::

   \begin{aligned}
   L_1 & = \sum_{i = 1}^{2} 2^{i - 1} k_i \\
       & = \underbrace{2^1 \cdot k_2}_{i = 2} + \underbrace{2^0 \cdot k_1}_{i = 1} \\
       & = 2 \cdot 1 + 1 \cdot 1 \\
       & = 3
   \end{aligned}

Essentially, :math:`L_j` is just :math:`k` shifted to the right by
:math:`j` bits. Shifting to the right by one bit is the same thing as
flooring division by two, just like right-shifting by a decimal digit is
the same thing as flooring division by 10. For example: 73, shifted one
decimal digit to the right is 7; 0b101 (5) shifted one binary digit
(bit) to the right is 0b10 (2). Analogously, shifting left is the
inverse operation, and is equivalent to *multiplying* by two.

Next, we'll perform a little arithmetical hocus pocus. First of all:

.. math::

   L_j = 2 \cdot L_{j + 1} + k_j

While you can verify this arithmetically, the easiest way to check this
is to think of it in terms of right and left shifts. If you shift
:math:`k` to the right by :math:`j` positions, that

.. math::

   \begin{aligned}
   k                               & = \mathtt{0b110010111} \\
   L_j               = L_2         & = \mathtt{0b1100101} \\
   L_{j + 1}         = L_3         & = \mathtt{0b110010} \\
   2 \cdot L_{j + 1} = 2 \cdot L_3 & = \mathtt{0b1100100}
   \end{aligned}

You can visually verify that :math:`L_2` is indeed :math:`L_3`, shifted
one to the left (which is the same thing as multiplying by two), plus
that one bit :math:`k_j` that “fell off” when shifting right.
:math:`k_j` is the last bit of :math:`L_j`; in this case it happens to
be 1, but it could equally well have been 0.

We define another very simple function :math:`H_j`:

.. math::

   H_j = L_j + 1 \iff L_j = H_j - 1

Starting from our previous result:

.. math::

   \begin{aligned}
   L_j & = 2 \cdot L_{j + 1} + k_j \\
       & \Downarrow (L_{j + 1} = H_{j+1} - 1) \\
   L_j & = L_{j + 1} + k_j + H_{j + 1} - 1 \\
       & \Downarrow (L_{j + 1} = H_{j+1} - 1) \\
   L_j & = 2 \cdot H_{j + 1} + k_j - 2
   \end{aligned}

We can combine these to produce an inductive way to compute :math:`L_j`
and :math:`H_j`:

.. math::

   L_j = \begin{cases}
   2 L_{j + 1}           & \mbox{if } k_j = 0, \\
   L_{j + 1} + H_{j + 1} & \mbox{if } k_j = 1.
   \end{cases}

.. math::

   H_j = \begin{cases}
   L_{j + 1} + H_{j + 1} & \mbox{if } k_j = 0, \\
   2 H_{j + 1} & \mbox{if } k_j = 1.
   \end{cases}

Remember that we're doing this to compute :math:`g^k`. Let's write the
exponentiation out:

.. math::

   g^{L_j} = \begin{cases}
   g^{2 L_{j + 1}} = \left(g^{L_{j + 1}}\right)^2 & \mbox{if } k_j = 0, \\
   g^{L_{j + 1} + H_{j + 1}} = g^{L_{j + 1}} \cdot g^{H_{j+1}} & \mbox{if } k_j = 1.
   \end{cases}

.. math::

   g^{H_j} = \begin{cases}
   g^{L_{j + 1} + H_{j + 1}} = g^{L_{j + 1}} \cdot g^{H_{j+1}} & \mbox{if } k_j = 0, \\
   g^{2 H_{j + 1}} = \left(g^{H_{j + 1}}\right)^2 & \mbox{if } k_j = 1.
   \end{cases}

Remember that :math:`L_j` is :math:`k` right-shifted by :math:`j` bits,
so :math:`L_0` is :math:`k` shifted right by 0 bits, or just :math:`k`
itself. That means :math:`g^k`, the number we're trying to compute, is
the same thing as :math:`g^{L_0}`. By starting at :math:`g^{L_{t - 1}}`
(:math:`g` raised to the power of the leftmost bit of :math:`k`) and
iteratively making our way down to :math:`g^{L_0} = g^k`, we have an
elegant inductive method for computing :math:`g^k` based on two simple
recursive rules.

The important part about this algorithm is the constant number of
operations. If :math:`k_j = 0`, computing :math:`g^{L_j}` involves one
squaring and :math:`g^{H_j}` involves one multiplication; if
:math:`k_j = 1`, it's the other way around. No matter what any of the
bits of :math:`k` are, you need one squaring operation and one
multiplication per bit.

Implementing the Montgomery ladder in Python
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The Python implementation of this algorithm, applied to modular
exponentiation, is surprisingly terse:

.. code:: python

   def montgomery(x, exponent, modulus):
       x1, x2 = x, x ** 2
       high_bit, *remaining_bits = bits(exponent)
       for bit in remaining_bits:
           if bit == 0:
               x2 = x1 * x2
               x1 = x1 ** 2
           else:
               x1 = x1 * x2
               x2 = x2 ** 2
           x1, x2 = x1 % modulus, x2 % modulus
       return x1

This code block doesn't show the definition of ``bits``: it produces the
binary expansion of its argument. Python doesn't provide that by
default; ``bin`` is close, but that produces a string: ``bin(100)``
evaluates to ``0b1100100``. The ``a, *b = bits(...)`` construct assigns
the first item in ``bits(...)`` to ``a``, and all remaining bits to
``b``, effectively just skipping the first bit.

The important thing to note here is that no matter what the particular
value of the exponent is, there is one squaring, one multiplication, and
one modulo operation per bit. Keep in mind that this doesn't necessarily
make the entire algorithm take constant time, because the individual
squaring and multiplication operations are not necessarily constant
time.

Discrete logarithm
~~~~~~~~~~~~~~~~~~

Just like subtraction is the inverse of addition, and division is the
inverse of multiplication, logarithms are the inverse of exponentiation.
In regular arithmetic, :math:`b^x = y`, if :math:`x = \log_b
y`. This is pronounced “:math:`b` raised to the power :math:`x` is
:math:`y`”, and “the logarithm of :math:`y` with respect to :math:`b` is
:math:`x`”. The equivalent of this in modular arithmetic is called a
“discrete logarithm”.

As with division, if you start from the definition as the inverse of a
different operator, it's easy to come up with examples. For example,
since :math:`3^6 \equiv 9 \pmod {15}`, we can define
:math:`6 \equiv \log_3 9 \pmod {15}`. Unlike modular inverses, computing
discrete logarithms is generally hard. There is no formal proof that computing
discrete logarithms is *intrinsically* complex; we just haven't found any
efficient algorithms to do it. Because this field has gotten extensive
research and we still don't have very fast general algorithms, we
consider it safe to base the security of protocols on the assumption
that computing discrete logs is hard.

There is one theoretical algorithm for computing discrete logarithms
efficiently. However, it requires a quantum computer, which is a
fundamentally different kind of computer from the classical computers we
use today. While we can build such computers, we can only build very
small ones. The limited size of our quantum computers strongly limits
which problems we can solve. So far, they're much more in the realm of
the kind of arithmetic a child can do in their head, than ousting the
top of the line classical computers from the performance throne.

The complexity of computing discrete logarithms, together with the
relative simplicity of computing its inverse, modular exponentiation, is
the basis for many public key cryptosystems. Common examples include the
RSA encryption primitive, and the Diffie-Hellman key exchange protocol.

While cryptosystems based on the discrete logarithm problem are
currently considered secure with appropriate parameter choices, there
are certainly ways that could change in the future. For example:

-  Theoretical breakthroughs in number theory could make discrete
   logarithms significantly easier to compute than we currently think.
-  Technological breakthroughs in quantum computing could lead to large
   enough quantum computers.
-  Technological breakthroughs in classical computing as well as the
   continuous gradual increases in performance and decreases in cost
   could increase the size of some problems that can be tackled using
   classical computers.

Discrete logarithm computation is tightly linked to the problem of
number factorization. They are still areas of active mathematical
research; the links between the two problems are still not thoroughly
understood. That said, there are many similarities between the two:

-  Both are believed to be hard to compute on classical computers, but
   neither has a proof of that fact.
-  They can both be efficiently computed on quantum computers using
   Shor's algorithm.
-  Mathematical advances in one are typically quickly turned into
   mathematical advances in the other.

.. _multiplicative-order:

Multiplicative order
~~~~~~~~~~~~~~~~~~~~

Given integer :math:`a` and positive integer :math:`b` with
gcd\ :math:`(a, b) = 1`, the *multiplicative order* of
:math:`a \pmod{b}` is the smallest positive integer :math:`k` such that
:math:`a^k = 1 \pmod{b}`.

.. _elliptic-curves:

Elliptic curves
---------------

Like modular arithmetic, elliptic curve arithmetic is used for many
public key cryptosystems. Many cryptosystems that traditionally work
with modular arithmetic, such as Diffie-Hellman and DSA, have an
elliptic curve counterpart.

Elliptic curves are curves with the following form:

.. math::

   y^2 = x^3 + ax + b

This is called the “short Weierstrass form”, and is the most common form
when talking about elliptic curves in general. There are several other
forms which mostly have applications in cryptography, notably the
Edwards form:

.. math::

   x^2 + y^2 = 1 + dx^2y^2

We can define addition of points on the curve.

TODO: Move the Abelian group thing somewhere else, since it applies to
our fields thing as well

All of this put together form something called an Abelian group. That's
a scary-sounding mathematical term that almost everyone already
understands the basics of. Specifically, if you know how to add integers
(:math:`\ldots -2, -1, 0, 1, 2, \ldots`) together, you already know an
Abelian group. An Abelian group satisfies five properties:

#. If :math:`a` and :math:`b` are members of the Abelian group and
   :math:`\star` is the operator, then :math:`a \star b` is also a
   member of that Abelian group. Indeed, any two integers added together
   always get you another integer. This property is called *closure*,
   or, we say that the group is *closed under addition* (or whatever the
   name is of the operation we've defined).
#. If :math:`a`, :math:`b` and :math:`c` are members of the Abelian
   group, the order of operations doesn't matter; to put it differently:
   we can move the brackets around. In equation form:
   :math:`(a \star b) \star c = a \star (b \star c)`. Indeed, the order in which
   you add integers together doesn't matter; they will always sum up to the same
   value. This property is called *associativity*, and the group is said to be
   *associative*.
#. There's exactly one identity element :math:`i`, for which
   :math:`a \star i = i \star a = a`. For integer addition, that's zero:
   :math:`a + 0 = 0 + a = a` for all a.
#. For each element :math:`a`, there's exactly one inverse element
   :math:`b`, for which :math:`a \star b = b \star a = i`, where
   :math:`i` is the identity element. Indeed, for integer addition,
   :math:`a + (-a) = (-a) + a = 0` for all a.
#. The order of elements doesn't matter for the result of the operation.
   For all elements :math:`a, b`, :math:`a \star b = b \star a`. This is
   known as *commutativity*, and the group is said to be *commutative*.

The first four properties are called group properties and make something
a group; the last property is what makes a group Abelian.

We can see that our elliptic curve, with the point at infinity and the
addition operator, forms an Abelian group:

#. If :math:`P` and :math:`Q` are two points on the elliptic curve, then
   :math:`P + Q` is also always a point on the curve.
#. If :math:`P`, :math:`Q`, and :math:`R` are all points on the curve,
   then :math:`P + (Q + R) = (P + Q) + R`, so the elliptic curve is associative.
#. There's an identity element, our point at infinity :math:`O`. For all
   points on the curve :math:`P`, :math:`P + O = O + P = P`.
#. Each element has an inverse element. This is easiest explained
   visually TODO: Explain visually
#. The order of operations doesn't matter, :math:`P + Q = Q + P` for all
   :math:`P, Q` on the curve.

The elliptic curve discrete log problem
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

TODO: explain fully

As with the regular discrete log problem, the elliptic curve discrete
log problem doesn't actually have a formal proof that the operation is
“hard” to perform: we just know that there is no publicly available
algorithm to do it efficiently. It's possible, however unlikely, that
someone has a magical algorithm that makes the problem easy, and that
would break elliptic curve cryptography completely. It's far more likely
that we will see a stream of continuous improvements, which coupled with
increased computing power eventually eat away at the security of the
algorithm.

Side-channel attacks
--------------------

Timing attacks
~~~~~~~~~~~~~~

AES cache timing
^^^^^^^^^^^^^^^^

http://tau.ac.il/~tromer/papers/cache.pdf

Elliptic curve timing attacks
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

TODO: Explain why the edwards form is great?

Power measurement attacks
~~~~~~~~~~~~~~~~~~~~~~~~~

TODO: Say something here.
