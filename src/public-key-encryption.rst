Public-key encryption
---------------------

.. _description-4:

Description
~~~~~~~~~~~

So far, we have only done :term:`secret-key encryption`. Suppose that you could
have a cryptosystem that didn't involve a single secret key, but instead
had a key pair: one public key, which you freely distribute, and a
private one, which you keep to yourself.

People can encrypt information intended for you by using your public
key. The information is then impossible to decipher without your private
key. This is called :term:`public-key encryption`.

For a long time, people thought this was impossible. However, starting
in the 1970s, such algorithms started appearing. The first publicly
available encryption scheme was produced by three cryptographers from
MIT: Ron Rivest, Adi Shamir and Leonard Adleman. The algorithm they
published is still the most common one today, and carries the first
letters of their last names: RSA.

:term:`public-key algorithm`\s aren't limited to encryption. In fact, you've
already seen a :term:`public-key algorithm` in this book that isn't directly
used for encryption. There are actually three related classes of
:term:`public-key algorithm`\s:

#. :term:`Key exchange <key exchange>` algorithms, such as Diffie-Hellman, which allow you to
   agree on a shared secret across an insecure medium.
#. Encryption algorithms, such as the ones we'll discuss in this
   chapter, which allow people to encrypt without having to agree on a
   shared secret.
#. Signature algorithms, which we'll discuss in a later chapter, which
   allow you to sign any piece of information using your private key in
   a way that allows anyone else to easily verify it using your public
   key.

Why not use public-key encryption for everything?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

At face value, it seems that :term:`public-key encryption` algorithms obsolete
all our previous :term:`secret-key encryption` algorithms. We could just use
public key encryption for everything, avoiding all the added complexity
of having to do :term:`key agreement` for our symmetric algorithms. However,
when we look at practical cryptosystems, we see that they're almost
always *hybrid* cryptosystems: while :term:`public-key algorithm`\s play a very
important role, the bulk of the encryption and authentication work is
done by secret-key algorithms.

By far the most important reason for this is performance. Compared to
our speedy :term:`stream cipher`\s (native or otherwise), :term:`public-key encryption`
mechanisms are extremely slow. For example, with a 2048-bit (256 bytes)
RSA key, encryption takes 0.29 megacycles, and decryption takes a whopping
11.12 megacycles. :cite:`cryptopp:bench` To put this into perspective,
symmetric key algorithms work within an order of magnitude of 10 or so
cycles per byte in either direction. This means it will take a symmetric
key algorithm approximately 3 kilocycles in order to decrypt 256 bytes,
which is about 4000 times faster than the asymmetric version. The state
of the art in secure symmetric ciphers is even faster: AES-GCM with
hardware acceleration or Salsa20/ChaCha20 only need about 2 to 4 cycles
per byte, further widening the performance gap.

There are a few other problems with most practical cryptosystems. For
example, RSA can't encrypt anything larger than its modulus, which
generally doesn't exceed 4096 bits, far smaller than the largest
messages we'd like to send. Still, the most important reason is the
speed argument given above.

RSA
~~~

As we already mentioned, RSA is one of the first practical
:term:`public-key encryption` schemes. It remains the most common scheme today.

Encryption and decryption
^^^^^^^^^^^^^^^^^^^^^^^^^

RSA encryption and decryption relies on modular arithmetic. You may want
to review the :ref:`modular arithmetic primer <modular-arithmetic>`
before continuing.

This section describes the simplified math problem behind RSA 
known as “textbook RSA”. RSA does not produce a secure
encryption scheme by itself. OAEP, a secure construction 
builds on top of RSA, which is discussed in a later section.

In order to generate a key, you select two large prime numbers :math:`p`
and :math:`q`. The numbers are picked at random, and secretly.
Multiplying them together produces the modulus :math:`N`, which is
public. Then, you pick an *encryption exponent* :math:`e`, which is also
public. Usually, the resulting value is either 3 or 65537. Since those numbers
have a small amount of ``1``'s in their binary expansion, you can
compute the exponentiation more efficiently. Combined,
:math:`(N, e)` is the public key. Anyone can use the public key to
encrypt a message :math:`M` into a ciphertext :math:`C`:

.. math::

   C \equiv M^e \pmod{N}

Decryption is the next problem. It turns out that there is a value
:math:`d`, the *decryption exponent*, that transforms :math:`C` back into
:math:`M`. The value is fairly easy to compute assuming that
:math:`p` and :math:`q` are known. Using :math:`d`, you can decrypt
the message like so:

.. math::

   M \equiv C^d \pmod{N}

The security of RSA lies in the decryption operation being impossible
to figure out without knowing the secret exponent :math:`d`. The secret
exponent :math:`d` is very hard (practically impossible) to compute from
the public key :math:`(N, e)`. We see approaches for breaking RSA in
the next section.

Breaking RSA
^^^^^^^^^^^^

Like many cryptosystems, RSA relies on the presumed difficulty of a
particular mathematical problem. For RSA specifically, this is the RSA problem:
to find the plaintext message :math:`M`, given a
ciphertext :math:`C`, and public key :math:`(N, e)` in the equation:

.. math::

   C \equiv M^e \pmod{N}

The easiest approach is by factoring :math:`N` back into
:math:`p \cdot q`. Given :math:`p` and :math:`q`, the attacker repeats
the same steps as the legitimate key owner during key
generation to compute the private exponent :math:`d`.

Fortunately, we do not have an algorithm that factors such large
numbers in reasonable time. Unfortunately, we also have not proven its
nonexistence. Even more unfortunate is that Shor's algorithm, a theoretical
algorithm, *would* factor such
a number in reasonable time on a quantum computer. Right now, quantum
computers are far from practical. Though if someone in
the future builds a sufficiently large quantum computer, RSA becomes
ineffective.

In this section, we only saw a private key recovery attack
that targets the abstract mathematical RSA problem by factoring the modulus.
In the next section, we see all sorts of realistic
attacks on RSA. They rely on flaws in the *implementation*, rather than
the mathematical problem stated above.

Implementation pitfalls
^^^^^^^^^^^^^^^^^^^^^^^

Currently, no practical complete breaks exist against RSA.
It is not to say that systems employing RSA are not routinely broken.
Like with most broken cryptosystems, there are plenty of cases where
sound components, improperly applied, result in a useless system. For a
more complete overview of what can go wrong with RSA
implementations, please refer to :cite:`boneh:twentyyears`
and :cite:`anderson:mindingyourpsandqs`. In this book, we
just highlight a few interesting ones.

PKCSv1.5 padding
''''''''''''''''

Salt
''''

Salt [#]_ is a provisioning system written in Python. Salt has one major
flaw: a module named ``crypt``. Instead of reusing existing
complete cryptosystems, Salt implements its own. It also uses RSA and AES
from a third party package.

.. [#]
   So, there is Salt the provisioning system, :term:`salt`\s the things used in
   broken password stores, NaCl pronounced “salt” the cryptography
   library, and NaCl which runs native code in some browsers, and
   probably a bunch I'm forgetting. Can we stop naming things after it?

For a long time, Salt used a public exponent (:math:`e`) of 1. This
meant the encryption phase did not do anything:
:math:`P^e \equiv P^1 \equiv P \pmod N`. The resulting ciphertext was in fact
just the plaintext. While this issue is fixed, this goes
to show that you probably should not implement your own cryptography.
Salt also supports SSH as a transport, however, the aforementioned
DIY RSA/AES system remains, and is at the time of writing still the
recommended, default transport.

OAEP
^^^^

OAEP is short for optimal asymmetric encryption padding. OAEP is 
state-of-the-art RSA padding first introduced by Mihir Bellare and Phillip
Rogaway in 1995. :cite:`bellarerogaway:oaep`. Its structure
looks like this:

.. figure:: Illustrations/OAEP/Diagram.svg
   :align: center

:math:`X \| Y` eventually gets encrypted, which is
:math:`n` bits long, and :math:`n` is the number of bits in :math:`N`,
the RSA modulus. It takes a random block :math:`R` that is :math:`k` bits
long, where :math:`k` is a constant specified by the standard. The
message is first padded with zeroes to be :math:`n - k` bits long. 
Looking at the above “ladder”, everything on the left half is
:math:`n - k` bits long, and everything on the right half is :math:`k`
bits long. The random block :math:`R` and zero-padded message
:math:`M \| 000\ldots` combine using two “trapdoor” functions, :math:`G` and
:math:`H`. A trapdoor function is very easy to compute
in one direction and very hard to reverse. In practice, these are 
cryptographic hash functions, which we see more about later.

As you can tell from the diagram, :math:`G` takes :math:`k` bits and
turns them into :math:`n - k` bits, and :math:`H` is the other way
around, taking :math:`n - k` bits and turning them into :math:`k` bits.

The resulting blocks :math:`X` and :math:`Y` are concatenated, and the
result is encrypted using the standard RSA encryption primitive, to
produce the ciphertext.

To see how decryption works, we reverse all the steps. The recipient
gets :math:`X \| Y` when decrypting the message. They know :math:`k`,
since it is a fixed parameter of the protocol, so they can split up
:math:`X \| Y` into :math:`X` (the first :math:`n - k` bits) and
:math:`Y` (the final :math:`k` bits).

In the previous diagram, the directions are for padding being applied.
Reverse the arrows on the side of the ladder, and you can see how to
revert the padding:

TODO: reverse arrows

We want to get to :math:`M`, which is in :math:`M \| 000\ldots`. There's
only one way to compute that, which is:

.. math::

   M \| 000\ldots = X \xor G(R)

Computing :math:`G(R)` is a little harder:

.. math::

   G(R) = G(H(X) \xor Y)

As you can see, at least for some definitions of the functions :math:`H`
and :math:`G`, we need all of :math:`X` and all of :math:`Y` (and hence
the entire encrypted message) in order to learn anything about
:math:`M`. There are many functions that would be a good choice for
:math:`H` and :math:`G`; based on cryptographic hash functions, which
we'll discuss in more detail later in the book.

Elliptic curve cryptography
~~~~~~~~~~~~~~~~~~~~~~~~~~~

TODO: This

Remaining problem: unauthenticated encryption
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Most :term:`public-key encryption` schemes can only encrypt small chunks of data
at a time, much smaller than the messages we want to be able to send.
They are also generally quite slow, much slower than their symmetric
counterparts. Therefore public-key cryptosystems are almost always used
in conjunction with secret-key cryptosystems.

When we discussed :term:`stream cipher`\s, one of the remaining issues that we
were facing was that we still had to exchange secret keys with a large
number of people. With public-key cryptosystems such as public
encryption and :term:`key exchange` protocols, we've now seen two ways that we
can solve that problem. That means that we can now communicate with
anyone, using only public information, completely secure from
eavesdroppers.

So far we've only been talking about encryption without any form of
authentication. That means that while we can encrypt and decrypt
messages, we cannot verify that the message is what the sender actually
sent.

While unauthenticated encryption may provide secrecy, we have already
seen that without authentication an active attacker can generally modify
valid encrypted messages successfully, despite the fact that they don't
necessarily know the corresponding plaintext. Accepting these messages
can often lead to secret information being leaked, meaning we don't even
get secrecy. The CBC padding attacks we've already discussed illustrate
this.

As a result it has become evident that we need ways to authenticate as
well as encrypt our secret communications. This is done by adding extra
information to the message that only the sender could have computed.
Just like encryption, authentication comes in both private-key
(symmetric) and public-key (asymmetric) forms. Symmetric authentication
schemes are typically called :term:`message authentication code`\s, while the
public-key equivalent is typically called a signature.

First, we will introduce a new cryptographic primitive: hash functions.
These can be used to produce both signature schemes as well as message
authentication schemes. Unfortunately, they are also very often abused
to produce entirely insecure systems.
