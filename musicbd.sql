PGDMP  7                    |         	   musicshop    17.2    17.2 1    X           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            Y           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            Z           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            [           1262    32778 	   musicshop    DATABASE     }   CREATE DATABASE musicshop WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE musicshop;
                     postgres    false            �            1259    32810 
   cart_items    TABLE     �   CREATE TABLE public.cart_items (
    id integer NOT NULL,
    user_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.cart_items;
       public         heap r       postgres    false            �            1259    32809    cart_items_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cart_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.cart_items_id_seq;
       public               postgres    false    222            \           0    0    cart_items_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.cart_items_id_seq OWNED BY public.cart_items.id;
          public               postgres    false    221            �            1259    32848    order_items    TABLE     �   CREATE TABLE public.order_items (
    id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    unit_price numeric(10,2) NOT NULL
);
    DROP TABLE public.order_items;
       public         heap r       postgres    false            �            1259    32847    order_items_id_seq    SEQUENCE     �   CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.order_items_id_seq;
       public               postgres    false    226            ]           0    0    order_items_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;
          public               postgres    false    225            �            1259    32829    orders    TABLE       CREATE TABLE public.orders (
    id integer NOT NULL,
    user_id integer NOT NULL,
    order_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    total_amount numeric(10,2) NOT NULL,
    status character varying(50) DEFAULT 'Pending'::character varying
);
    DROP TABLE public.orders;
       public         heap r       postgres    false            �            1259    32828    orders_id_seq    SEQUENCE     �   CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.orders_id_seq;
       public               postgres    false    224            ^           0    0    orders_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;
          public               postgres    false    223            �            1259    32789    products    TABLE     �   CREATE TABLE public.products (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    price numeric(10,2) NOT NULL,
    image_url character varying(255),
    category character varying(255)
);
    DROP TABLE public.products;
       public         heap r       postgres    false            �            1259    32788    products_id_seq    SEQUENCE     �   CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.products_id_seq;
       public               postgres    false    218            _           0    0    products_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;
          public               postgres    false    217            �            1259    32798    users    TABLE        CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.users;
       public         heap r       postgres    false            �            1259    32797    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public               postgres    false    220            `           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public               postgres    false    219            �           2604    32813    cart_items id    DEFAULT     n   ALTER TABLE ONLY public.cart_items ALTER COLUMN id SET DEFAULT nextval('public.cart_items_id_seq'::regclass);
 <   ALTER TABLE public.cart_items ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    221    222    222            �           2604    32851    order_items id    DEFAULT     p   ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);
 =   ALTER TABLE public.order_items ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    225    226    226            �           2604    32832 	   orders id    DEFAULT     f   ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);
 8   ALTER TABLE public.orders ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    223    224    224            �           2604    32792    products id    DEFAULT     j   ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);
 :   ALTER TABLE public.products ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    218    217    218            �           2604    32801    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    219    220    220            Q          0    32810 
   cart_items 
   TABLE DATA           S   COPY public.cart_items (id, user_id, product_id, quantity, created_at) FROM stdin;
    public               postgres    false    222   �9       U          0    32848    order_items 
   TABLE DATA           U   COPY public.order_items (id, order_id, product_id, quantity, unit_price) FROM stdin;
    public               postgres    false    226   :       S          0    32829    orders 
   TABLE DATA           O   COPY public.orders (id, user_id, order_date, total_amount, status) FROM stdin;
    public               postgres    false    224   c:       M          0    32789    products 
   TABLE DATA           H   COPY public.products (id, name, price, image_url, category) FROM stdin;
    public               postgres    false    218   �:       O          0    32798    users 
   TABLE DATA           J   COPY public.users (id, username, email, password, created_at) FROM stdin;
    public               postgres    false    220   <       a           0    0    cart_items_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.cart_items_id_seq', 17, true);
          public               postgres    false    221            b           0    0    order_items_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.order_items_id_seq', 7, true);
          public               postgres    false    225            c           0    0    orders_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.orders_id_seq', 3, true);
          public               postgres    false    223            d           0    0    products_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.products_id_seq', 14, true);
          public               postgres    false    217            e           0    0    users_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.users_id_seq', 4, true);
          public               postgres    false    219            �           2606    32817    cart_items cart_items_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.cart_items DROP CONSTRAINT cart_items_pkey;
       public                 postgres    false    222            �           2606    32854    order_items order_items_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.order_items DROP CONSTRAINT order_items_pkey;
       public                 postgres    false    226            �           2606    32836    orders orders_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public                 postgres    false    224            �           2606    32796    products products_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.products DROP CONSTRAINT products_pkey;
       public                 postgres    false    218            �           2606    32808    users users_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key;
       public                 postgres    false    220            �           2606    32804    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public                 postgres    false    220            �           2606    32806    users users_username_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key;
       public                 postgres    false    220            �           2606    32823 %   cart_items cart_items_product_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);
 O   ALTER TABLE ONLY public.cart_items DROP CONSTRAINT cart_items_product_id_fkey;
       public               postgres    false    222    218    4774            �           2606    32818 "   cart_items cart_items_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);
 L   ALTER TABLE ONLY public.cart_items DROP CONSTRAINT cart_items_user_id_fkey;
       public               postgres    false    4778    222    220            �           2606    32855 %   order_items order_items_order_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.order_items DROP CONSTRAINT order_items_order_id_fkey;
       public               postgres    false    226    4784    224            �           2606    32865 &   order_items order_items_order_id_fkey1    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey1 FOREIGN KEY (order_id) REFERENCES public.orders(id);
 P   ALTER TABLE ONLY public.order_items DROP CONSTRAINT order_items_order_id_fkey1;
       public               postgres    false    224    226    4784            �           2606    32860 '   order_items order_items_product_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);
 Q   ALTER TABLE ONLY public.order_items DROP CONSTRAINT order_items_product_id_fkey;
       public               postgres    false    4774    218    226            �           2606    32870 (   order_items order_items_product_id_fkey1    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey1 FOREIGN KEY (product_id) REFERENCES public.products(id);
 R   ALTER TABLE ONLY public.order_items DROP CONSTRAINT order_items_product_id_fkey1;
       public               postgres    false    4774    226    218            �           2606    32837    orders orders_user_id_fkey    FK CONSTRAINT     y   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);
 D   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_user_id_fkey;
       public               postgres    false    224    220    4778            �           2606    32842    orders orders_user_id_fkey1    FK CONSTRAINT     z   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey1 FOREIGN KEY (user_id) REFERENCES public.users(id);
 E   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_user_id_fkey1;
       public               postgres    false    224    220    4778            Q      x������ � �      U   E   x�U���0�7c�N��]��u�JH�uJ2wf�݉�8��fN���g5����:w�r�����d��      S   b   x�eͱ�0Dњ���8�H�� e� ��/������^��}��h�P�g�<�
��^�������BaH1�ԑ'ow�C�����O-�� 9��      M   8  x�m��n�0�ϛ����@��@Q{i�ġ�^L�$.&�Ρo_��PLoy����>�xd[�h�i*���lkjг�#�ŕ�g�+��z����`�>{�O�Т��Вl�ݱ+=(ŗ��"V��F}��6��@�C}FB*������2�=Æ��k�'v�F��y�������	ڱ����dб-]�K�D��@b�>9LU�8 �2&�| �1��ڈ�O!��~]�pr?C�A�X���n
G}�C�M	�4�h���9�,���9��JX�=T��ۦ��X��p��XIC]UX���O�1�x�e��$�=      O   �   x�]�Mk�0 �s�;xM�$&M=��ұ���v�#�A%6~���}�`��ܞ �ʕӬV��a�Ӫ�R��r�b7!�>�d}9$�Vu.]���f�IU������2�j����<�W���4U�@��*�9	��k�A��ȟ���6�O\��w�x�)��y3v��H_p�n��$�M�"26�YES���Ŀ�A� ���;�<�H�     