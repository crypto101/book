Block ciphers
-------------

   Few false ideas have more firmly gripped the minds of so many intelligent men
   than the one that, if they just tried, they could invent a cipher that no one
   could break.

       *David Kahn*

.. _description-1:

Description
~~~~~~~~~~~

A :term:`block cipher` is an algorithm that encrypts blocks of a
fixed length. The encryption function :math:`E` transforms
plaintext blocks :math:`P` into ciphertext blocks :math:`C` by using a
secret key :math:`k`:

.. math::

   C = E(k, P)

Plaintext and ciphertext blocks are sequences of bits and always match in size. The 
block cipher's *block size* is a fixed size. :term:`Keyspace` is the set of all possible keys.

Once we encrypt plaintext blocks into ciphertext blocks, they are later
decrypted to recover original plaintext block. The original plaintext block
:math:`P` is produced using a decryption function :math:`D`. It takes the
ciphertext block :math:`C` and the key :math:`k` (same as the one used to
encrypt the block) as inputs.

.. math::

   P = D(k, C)

Or, visually represented in blocks:

.. figure:: Illustrations/BlockCipher/BlockCipher.svg
   :align: center

A block cipher is an example of a :term:`symmetric-key encryption` scheme, also
known as a :term:`secret-key encryption` scheme. The same secret
key is used for both encryption and decryption. Later in the book, we contrast this
with :term:`public-key encryption` algorithms, which have a distinct key for
encryption and decryption.

A block cipher is a *keyed permutation*. It is a *permutation* because 
the block cipher maps each possible block to another block. It is 
also a *keyed* permutation because the key determines exactly which 
blocks map to which. It is important for the block cipher to be a permutation because the
recipient must map blocks back to the original blocks.

We illustrate this by looking at a block cipher with an impractical,
tiny 4-bit block size. :math:`2^4 = 16` possible blocks. Since each
of the blocks map to a hexadecimal digit, we represent the blocks
by that digit. :numref:`fig-BlockCipherBlocks`
illustrates blocks that the cipher operates on.


.. _fig-BlockCipherBlocks:

.. figure:: Illustrations/BlockCipher/AllNodes.svg
   :align: center

   All 16 nodes operated on by the block cipher. Each node is designated by a hexadecimal digit.

Once we select a secret key, the block cipher uses it to determine
the encryption of any given block. We illustrate that
relationship with an arrow. The tail of the arrow has the block
encrypted with :math:`E` under key :math:`k` and the arrowhead is mapped to the block.

.. _fig-BlockCipherEncryption:

.. figure:: Illustrations/BlockCipher/Encryption.svg
   :align: center

   An encryption permutation made by a block cipher under a particular key :math:`k`.

In :numref:`fig-BlockCipherEncryption`, note
that the permutation is not just one big cycle. It contains a large cycle of
7 elements, and several smaller cycles of 4, 3 and 2 elements each. It is
also perfectly possible that an element encrypts to itself. This is to
be expected when selecting random permutations, which is approximately
what a block cipher is doing; it doesn't demonstrate a bug in the block
cipher.

When you decrypt instead of encrypt, the block cipher 
computes the inverse permutation. In :numref:`fig-BlockCipherDecryption`,
we get the same illustration. The difference between the illustrations is that all arrowheads point
in the opposite direction.

.. _fig-BlockCipherDecryption:

.. figure:: Illustrations/BlockCipher/Decryption.svg
   :align: center

   The decryption permutation produced by the block cipher under the same key
   :math:`k`. It is the inverse of the encryption permutation in that all arrowheads
   reverse.


The key defines which blocks map to which blocks. 
A different key would lead to a different set of
arrows, as you can see in :numref:`fig-BlockCipherEncryptionDifferentKey`.

.. _fig-BlockCipherEncryptionDifferentKey:

.. figure:: Illustrations/BlockCipher/Encryption2.svg
   :align: center

   An encryption permutation produced by the block cipher under a different key.

In this illustration, you'll even notice that there are two permutations
of length 1: an element that maps to itself. This is again something to
be expected when selecting random permutations.

Knowing a bunch of (input, output) pairs for a given key shouldn't give
you any information about any other (input, output) pairs under that
key [#]_. As long as we're talking about a hypothetical perfect block
cipher, there's no easier way to decrypt a block other than to
“brute-force” the key: i.e. just try every single one of them until you
find the right one.

.. [#]
   The attentive reader may have noticed that this breaks in the
   extremes: if you know all but one of the pairs, then you know the
   last one by exclusion.

Our toy illustration block cipher only has 4 bit blocks, or
:math:`2^4 = 16` possibilities. Real, modern block ciphers have much
larger block sizes, such as 128 bits, or :math:`2^{128}` (slightly more
than :math:`10^{38.5}`) possible blocks. Mathematics tells us that there
are :math:`n!` (pronounced “:math:`n` factorial”) different permutations
of an :math:`n` element set. It's defined as the product of all of the
numbers from 1 up to and including :math:`n`:

.. math::

   n! = 1 \cdot 2 \cdot 3 \cdot \ldots \cdot (n - 1) \cdot n

Factorials grow incredibly quickly. For example, :math:`5! = 120`,
:math:`10! = 3628800`, and the rate continues to increase. The number of permutations
of the set of blocks of a cipher with a 128 bit block size is
:math:`(2^{128})!`. Just :math:`2^{128}` is large already (it takes 39
digits to write it down), so :math:`(2^{128})!` is a mind-bogglingly
huge number, impossible to comprehend. Common key sizes are only in the
range of 128 to 256 bits, so there are only between :math:`2^{128}` and
:math:`2^{256}` permutations a cipher can perform. That's just a tiny
fraction of all possible permutations of the blocks, but that's okay:
that tiny fraction is still nowhere near small enough for an attacker to
just try them all.

Of course, a block cipher should be as easy to compute as possible, as
long as it doesn't sacrifice any of the above properties.

AES
~~~

The most common block cipher in current use is AES.

Contrary to its predecessor DES (which we'll look at in more detail in
the next chapter), AES was selected through a public, peer-reviewed
competition that arose from an open call for proposals. The competition
involved several rounds of contestant presentations,
subject to extensive cryptanalysis, and voted upon. The AES process was
well-received among cryptographers. Similar processes are preferred 
for selecting cryptographic standards.

Prior to being chosen as the Advanced Encryption Standard, the algorithm
was known as Rijndael, a name derived from the two last names of the
Belgian cryptographers that designed it: Vincent Rijmen and Joan Daemen.
The Rijndael algorithm defined a family of block ciphers. The block
sizes and key sizes could be any multiple of 32 bits between 128
bits to 256 bits. :cite:`daemen:aes` When Rijndael became
AES through the FIPS standardization process, the parameters were
restricted to a block size of 128 bits and keys sizes of 128, 192 and
256 bits. :cite:`fips:aes`

No practical attacks exist against AES. While there have been
some developments in the last few years, most of them involve
related-key attacks :cite:`cryptoeprint:2009:317`, some of
them only on reduced-round versions of AES
:cite:`cryptoeprint:2009:374`.  [#]_

.. [#]
   Symmetric algorithms usually rely on a round function to be repeated
   a number of times. Typically each invocation involves a “round key”
   derived from the main key. A reduced-round version is intentionally
   easier to attack. These attacks can give insight as to how resistant
   the full cipher is.

   A related key attack involves predicting how AES
   behaves under different keys with specific
   mathematical relations. These relations are fairly simple, such as
   XORing with an attacker-chosen constant. If an attacker is allowed to
   encrypt and decrypt a large number of blocks with these related keys,
   they can attempt to recover the original key with significantly less
   computation than would ordinarily be necessary to crack it.

   While a theoretically, ideal block cipher would not be vulnerable to a
   related key attack, these attacks are not considered practical
   concerns. In practice cryptographic keys are generated via a
   cryptographically secure pseudorandom number generator, or a
   similarly secure :term:`key agreement` scheme, or a key derivation scheme (we'll
   see more about those later). Therefore, the odds of selecting two
   such related keys by accident is nonexistent. These attacks are
   interesting from an academic perspective: they provide
   insight in the workings of the cipher, guiding cryptographers in the
   design of future ciphers and attacks against current ciphers.

A closer look at Rijndael
^^^^^^^^^^^^^^^^^^^^^^^^^

.. canned_admonition::
   :from_template: advanced

AES consists of several independent steps. At a high level, AES is a
:term:`substitution-permutation network`.

Key schedule
''''''''''''

AES requires separate keys for each round in the next steps. The key
schedule is the process which AES uses to derive 128-bit keys for each
round from one master key.

First, the key is separated into 4 byte columns. The key is rotated and
then each byte is run through an S-box (substitution box) that maps it
to something else. Each column is then XORed with a round constant. The
last step is to XOR the result with the previous round key.

The other columns are then XORed with the previous round key to produce
the remaining columns.

SubBytes
''''''''

SubBytes is the step that applies the S-box (substitution box) in AES.
The S-box itself substitutes a byte with another byte, and this S-box is
applied to each byte in the AES state.

It works by taking the multiplicative inverse over the Galois field, and
then applying an affine transformation so that there are no values
:math:`x` so that :math:`x \xor S(x) = 0` or :math:`x \xor S(x)=\texttt{0xff}`.
To rephrase: there are no values of :math:`x` that the substitution box maps to
:math:`x` itself, or :math:`x` with all bits flipped. This makes the cipher
resistant to linear cryptanalysis, unlike the earlier DES algorithm,
whose fifth S-box caused serious security problems.  [#]_

.. figure:: Illustrations/AES/SubBytes.svg
   :align: center

.. [#]
   In its defense, linear attacks were not publicly known back when DES
   was designed.

ShiftRows
'''''''''

After having applied the SubBytes step to the 16 bytes of the block, AES
shifts the rows in the :math:`4 \times 4` array:

.. figure:: Illustrations/AES/ShiftRows.svg
   :align: center

MixColumns
''''''''''

MixColumns multiplies each column of the state with a fixed polynomial.

ShiftRows and MixColumns represent the diffusion properties of AES.

.. figure:: Illustrations/AES/MixColumns.svg
   :align: center

AddRoundKey
'''''''''''

As the name implies, the AddRoundKey step adds the bytes from the round
key produced by the key schedule to the state of the cipher.

.. figure:: Illustrations/AES/AddRoundKey.svg
   :align: center

DES and 3DES
~~~~~~~~~~~~

The DES is one of the oldest block ciphers that saw widespread use. It
was published as an official FIPS standard in 1977. It is no longer
considered secure, mainly due to its tiny key size of 56 bits. (The DES
algorithm actually takes a 64 bit key input, but the remaining 8 bits
are only used for parity checking, and are discarded immediately.) It
shouldn't be used in new systems. On modern hardware, DES can be brute
forced in less than a day. :cite:`sciengines:breakdes`

In an effort to extend the life of the DES algorithm, in a way that
allowed much of the spent hardware development effort to be reused,
people came up with 3DES: a scheme where input is first encrypted, then
decrypted, then encrypted again:

.. math::

   C = E_{DES}(k_1, D_{DES}(k_2, E_{DES}(k_3, p)))

This scheme provides two improvements:

-  By applying the algorithm three times, the cipher becomes harder to
   attack directly through cryptanalysis.
-  By having the option of using many more total key bits, spread over
   the three keys, the set of all possible keys becomes much larger,
   making brute-forcing impractical.

The three keys could all be chosen independently (yielding 168 key
bits), or :math:`k_3 = k_1` (yielding 112 key bits), or
:math:`k_1 = k_2 = k_3`, which, of course, is just plain old DES (with
56 key bits). In the last keying option, the middle decryption reverses
the first encryption, so you really only get the effect of the last
encryption. This is intended as a backwards compatibility mode for
existing DES systems. If 3DES had been defined as
:math:`E(k_1, E(k_2, E(k_3, p)))`, it would have been impossible to use
3DES implementations for systems that required compatibility with DES.
This is particularly important for hardware implementations, where it is
not always possible to provide a secondary, regular “single DES”
interface next to the primary 3DES interface.

Some attacks on 3DES are known, reducing their effective security. While
breaking 3DES with the first keying option is currently impractical,
3DES is a poor choice for any modern cryptosystem. The security margin
is already small, and continues to shrink as cryptographic attacks
improve and processing power grows.

Far better alternatives, such as AES, are available. Not only are they
more secure than 3DES, they are also generally much, much faster. On the
same hardware and in the same :term:`mode of operation` (we'll explain what that
means in the next chapter), AES-128 only takes 12.6 cycles per byte,
while 3DES takes up to 134.5 cycles per byte.
:cite:`cryptopp:bench` Despite being worse from a security
point of view, it is literally an order of magnitude slower.

While more iterations of DES might increase the security margin, they
aren't used in practice. First of all, the process has never been
standardized beyond three iterations. Also, the performance only becomes
worse as you add more iterations. Finally, increasing the key bits has
diminishing security returns, only increasing the security level of the
resulting algorithm by a smaller amount as the number of key bits
increases. While 3DES with keying option 1 has a key length of 168 bits,
the effective security level is estimated at only 112 bits.

Even though 3DES is significantly worse in terms of performance and
slightly worse in terms of security, 3DES is still the workhorse of the
financial industry. With a plethora of standards already in existence
and new ones continuing to be created, in such an extremely
technologically conservative industry where Fortran and Cobol still
reign supreme on massive mainframes, it will probably continue to be
used for many years to come, unless there are some large cryptanalytic
breakthroughs that threaten the security of 3DES.

.. _remaining-problems-1:

Remaining problems
~~~~~~~~~~~~~~~~~~

Even with block ciphers, there are still some unsolved problems.

For example, we can only send messages of a very limited length: the
block length of the block cipher. Obviously, we'd like to be able to
send much larger messages, or, ideally, streams of indeterminate size.
We'll address this problem with a :ref:`stream cipher <stream-ciphers>`.

Although we have reduced the key size drastically (from the total size
of all data ever sent under a one-time pad scheme versus a few bytes for
most block ciphers), we still need to address the issue of agreeing on
those few key bytes, potentially over an insecure channel. We'll address
this problem in a later chapter with a :ref:`key exchange protocol <key-exchange>`.
