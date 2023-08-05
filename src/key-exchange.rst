.. _key-exchange:

Key exchange
------------

.. _description-3:

Description
~~~~~~~~~~~

:term:`Key exchange <key exchange>` protocols attempt to solve a problem that, at first glance,
seems impossible. Alice and Bob, who've never met before, have to agree
on a secret value. The channel they use to communicate is insecure:
we're assuming that everything they send across the channel is being
eavesdropped on.

We'll demonstrate such a protocol here. Alice and Bob will end up having
a shared secret, only communicating over the insecure channel. Despite
Eve having literally all of the information Alice and Bob send to each
other, she can't use any of that information to figure out their shared
secret.

That protocol is called Diffie-Hellman, named after Whitfield Diffie and
Martin Hellman, the two cryptographic pioneers who discovered it. They
suggested calling the protocol Diffie-Hellman-Merkle :term:`key exchange`, to
honor the contributions of Ralph Merkle. While his contributions
certainly deserve honoring, that term hasn't really caught on. For the
benefit of the reader we'll use the more common term.

Practical implementations of Diffie-Hellman rely on mathematical
problems that are believed to be very complex to solve in the “wrong”
direction, but easy to compute in the “right” direction. Understanding
the mathematical implementation isn't necessary to understand the
principle behind the protocol. Most people also find it a lot easier to
understand without the mathematical complexity. So, we'll explain
Diffie-Hellman in the abstract first, without any mathematical
constructs. Afterwards, we'll look at two practical implementations.

Abstract Diffie-Hellman
~~~~~~~~~~~~~~~~~~~~~~~

In order to describe Diffie-Hellman, we'll use an analogy based on
mixing colors. We can mix colors according to the following rules:

-  It's very easy to mix two colors into a third color.
-  Mixing two or more colors in different order results in the same
   color.
-  Mixing colors is *one-way*. It's impossible to determine if, let
   alone which, multiple colors were used to produce a given color. Even
   if you know it was mixed, and even if you know some of the colors
   used to produce it, you have no idea what the remaining color(s)
   were.

We'll demonstrate that with a mixing function like this one, we can
produce a secret color only known by Alice and Bob. Later, we'll simply
have to describe the concrete implementation of those functions to get a
concrete :term:`key exchange` scheme.

To illustrate why this remains secure in the face of eavesdroppers,
we'll walk through an entire exchange with Eve, the eavesdropper, in the
middle. Eve is listening to all of the messages sent across the network.
We'll keep track of everything she knows and what she can compute, and
end up seeing *why* Eve can't compute Alice and Bob's shared secret.

To start the protocol, Alice and Bob have to agree on a base color. They
can communicate that across the network: it's okay if Eve intercepts the
message and finds out what the color is. Typically, this base color is a
fixed part of the protocol; Alice and Bob don't need to communicate it.
After this step, Alice, Bob and Eve all have the same information: the
base color.

.. figure:: ./Illustrations/DiffieHellman/alice-bob-eve.svg
   :align: center

Alice and Bob both pick a random color, and they mix it with the base
color.

.. figure:: ./Illustrations/DiffieHellman/alice-bob-secret.svg
   :align: center

At the end of this step, Alice and Bob know their respective secret
color, the mix of the secret color and the base color, and the base
color itself. Everyone, including Eve, knows the base color.

.. figure:: ./Illustrations/DiffieHellman/alice-bob-eve-secret.svg
   :align: center

Then, Alice and Bob both send their mixed colors over the network. Eve
sees both mixed colors, but she can't figure out what either of Alice
and Bob's *secret* colors are. Even though she knows the base, she can't
“un-mix” the colors sent over the network. [#]_

.. figure:: ./Illustrations/DiffieHellman/mixed-secret.svg
   :align: center

.. [#]
   While this might seem like an easy operation with black-and-white
   approximations of color mixing, keep in mind that this is just a
   failure of the illustration: our assumption was that this was hard.


At the end of this step, Alice and Bob know the base, their respective
secrets, their respective mixed colors, and each other's mixed colors.
Eve knows the base color and both mixed colors.

.. figure:: ./Illustrations/DiffieHellman/alice-bob-eve-mixed.svg
   :align: center


Once Alice and Bob receive each other's mixed color, they add their own
secret color to it. Since the order of the mixing doesn't matter,
they'll both end up with the same secret.

.. figure:: ./Illustrations/DiffieHellman/alice-bob-shared-mixed.svg
   :align: center

Eve can't perform that computation. She could finish the computation
with either Alice or Bob's secret color, since she has both mixed
colors, but she has neither of those secret colors. She can also try to
mix the two mixed colors, which would have both Alice and Bob's secret
colors mixed into them. However, that would have the base color in it
twice, resulting in a different color than the shared secret color that
Alice and Bob computed, which only has the base color in it once.

Diffie-Hellman with discrete logarithms
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This section describes a practical implementation of the Diffie-Hellman
algorithm, based on the discrete logarithm problem. It is intended to
provide some mathematical background, and requires modular arithmetic to
understand. If you are unfamiliar with modular arithmetic, you can
either skip this chapter, or first read the :ref:`mathematical background appendix
<modular-arithmetic>`.

Discrete log Diffie-Hellman is based on the idea that computing
:math:`y` in the following equation is easy (at least for a computer):

.. math::

   y \equiv g^x \pmod{p}

However, computing :math:`x` given :math:`y`, :math:`g` and :math:`p` is
believed to be very hard. This is called the discrete logarithm problem,
because a similar operation without the modular arithmetic is called a
logarithm.

This is just a concrete implementation of the abstract Diffie-Hellman
process we discussed earlier. The common base color is a large prime
:math:`p` and the base :math:`g`. The “color mixing” operation is the
equation given above, where :math:`x` is the input value and :math:`y`
is the resulting mixed value.

When Alice or Bob select their random numbers :math:`r_A` and
:math:`r_B`, they mix them with the base to produce the mixed numbers
:math:`m_A` and :math:`m_B`:

.. math::

   m_A \equiv g^{r_A} \pmod{p}

.. math::

   m_B \equiv g^{r_B} \pmod{p}

These numbers are sent across the network where Eve can see them. The
premise of the discrete logarithm problem is that it is okay to do so,
because figuring out :math:`r` in :math:`m \equiv g^r \pmod{p}` is
supposedly very hard.

Once Alice and Bob have each other's mixed numbers, they add their own
secret number to it. For example, Bob would compute:

.. math::

   s \equiv (g^{r_A})^{r_B} \pmod{p}

While Alice's computation looks different, they get the same result,
because :math:`(g^{r_A})^{r_B} \equiv (g^{r_B})^{r_A} \pmod{p}`. This is
the shared secret.

Because Eve doesn't have :math:`r_A` or :math:`r_B`, she can not perform
the equivalent computation: she only has the base number :math:`g` and
mixed numbers :math:`m_A \equiv g^{r_A} \pmod{p}` and
:math:`m_B \equiv g^{r_B} \pmod{p}` , which are useless to her. She
needs either :math:`r_A` or :math:`r_B` (or both) to make the
computation Alice and Bob do.

TODO: Say something about active MITM attacks where the attacker picks
smooth values to produce weak secrets?

Diffie-Hellman with elliptic curves
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This section describes a practical implementation of the Diffie-Hellman
algorithm, based on the elliptic curve discrete logarithm problem. It is
intended to provide some mathematical background, and requires a (very
basic) understanding of the mathematics behind elliptic curve
cryptography. If you are unfamiliar with elliptic curves, you can either
skip this chapter, or first read the :ref:`mathematical background appendix
<elliptic-curves>`.

One of the benefits of the elliptic curve Diffie-Hellman variant is that
the required key size is much, much smaller than the variant based on
the discrete log problem. This is because the fastest algorithms for
breaking the elliptic curve discrete log problem have a larger asymptotic
complexity than the non-elliptic variants. For example, the number field sieve
for discrete logarithms, a state of the art algorithm for attacking
discrete logarithm-based Diffie-Hellman, has time complexity:

.. math::

   L\left[1/3,\sqrt[3]{64/9}\right]

Which is more than polynomial (but less than exponential) in the number
of digits. On the other hand, the fastest algorithms that could be used
to break the elliptic curve discrete log problem all have complexity:

.. math::

   L\left[1, 1/2\right] = O(\sqrt{n})

Relatively speaking, that means that it's much harder to solve the
elliptic curve problem than it is to solve the regular discrete log
problem, using state of the art algorithms for both. The flip side of
that is that for equivalent security levels, the elliptic curve
algorithm needs much smaller key
sizes :cite:`rsa:keysizes` :cite:`nist:keymanagement` [#]_:

.. [#]
   These figures are actually for the RSA problem versus the equivalent
   elliptic curve problem, but their security levels are sufficiently
   close to give you an idea.

====================== ===================== =======================
Security level in bits Discrete log key bits Elliptic curve key bits
====================== ===================== =======================
56                     512                   112
80                     1024                  160
112                    2048                  224
128                    3072                  256
256                    15360                 512
====================== ===================== =======================

.. _remaining-problems-3:

Remaining problems
~~~~~~~~~~~~~~~~~~

Using Diffie-Hellman, we can agree on shared secrets across an insecure
Internet, safe from eavesdroppers. However, while an attacker may not be
able to simply get the secret from eavesdropping, an active attacker can
still break the system. If such an attacker, usually called Mallory, is
in between Alice and Bob, she can still perform the Diffie-Hellman
protocol twice: once with Alice, where Mallory pretends to be Bob, and
once with Bob, where Mallory pretends to be Alice.

.. figure:: ./Illustrations/DiffieHellman/MITM.svg
   :align: center

There are two shared secrets here: one between Alice and Mallory, and
one between Mallory and Bob. The attacker (Mallory) can then simply take
all the messages they get from one person and send them to the other,
they can look at the plaintext messages, remove messages, and they can
also modify them in any way they choose.

To make matters worse, even if one of the two participants was somehow
aware that this was going on, they would have no way to get the other
party to believe them. After all: Mallory performed the successful
Diffie-Hellman exchange with the unwitting victim, she has all the
correct shared secrets. Bob has no shared secrets with Alice, just with
Mallory; there's no way for him to prove that he's the legitimate
participant. As far as Alice can tell, Bob just chose a few random
numbers. There's no way to link any key that Bob has with any key that
Alice has.

Attacks like these are called MITM attacks, because the attacker
(Mallory) is in between the two peers (Alice and Bob). Given that the
network infrastructure that we typically use to send messages is run by
many different operators, this kind of attack scenario is very
realistic, and a secure cryptosystem will have to address them somehow.

While the Diffie-Hellman protocol successfully produced a shared secret
between two peers, there are clearly some pieces of the puzzle still
missing to build secure cryptosystems. We need tools that help us
authenticate Alice to Bob and vice versa, and we need tools that help
guarantee message integrity, allowing the receiver to verify that the
received messages are in fact the messages the sender intended to send.
