<?xml version="1.0" encoding="UTF-8"?>

<!-- Définition des namespaces -->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="tei"
  version="2.0">
  
  <!-- Sortie de la transformation : document HTML -->
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  <!-- Indique la sortie et le dossier CSS correspondant -->
  <xsl:variable name="sortie" select="'sortie/'"/>
  <xsl:variable name="css" select="'../corpus.css'"/>

<!-- Ici un header qui va s'appliquer sur toutes les pages du projet-->
  <xsl:variable name="head">
    <head>
      <meta charset="utf-8"/>
      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <link rel="stylesheet" href="../corpus.css"/>
      <title>Les archives Jean-Michel et Nicole Thierry : un projet d'édition numérique</title>
    </head>
  </xsl:variable>

  <!-- Même chose pour le footer -->
  <xsl:variable name="footer">
    <footer>
      <hr/>
      <p>Site réalisé par Maud Mélinand dans le cadre du cours de XSLT du Master TNAH de l'École nationale des chartes.</p>
    </footer>
  </xsl:variable>

  <!-- Définition de la barre de navigation : chaque élément TEI (lettre) est récupéré par son identifiant pour créer une page html dédiée -->
  <xsl:template name="navbar">
    <div id="navbar">
      <ul>
        <li><a href="home.html">Accueil</a></li>
        <xsl:for-each select="//teiCorpus/TEI">
          <li> — <a href="{@xml:id}.html">
            <xsl:value-of select=".//correspAction[@type='sent']/persName[1]"/>
            (<xsl:value-of select=".//correspAction[@type='sent']/date"/>)
          </a></li>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>

  <!--Première règle : génère le fichier home.html puis boucle sur les éléments TEI pour créer une page en appelant un template page-lettre défini plus bas -->
  <xsl:template match="/">
    <xsl:call-template name="home"/>
    <xsl:for-each select="//teiCorpus/TEI">
      <xsl:call-template name="page-lettre">
        <xsl:with-param name="lettre" select="."/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

<!-- Création du template home (accueil) -->
  <xsl:template name="home">
    <xsl:result-document href="out/home.html" method="html" indent="yes">
      <html>
        <xsl:copy-of select="$head"/>
        <body>
          <xsl:call-template name="navbar"/>
          <h1>Édition numérique de la correspondance scientifique<br/>
            de <em>Jean-Michel et Nicole Thierry</em></h1>
          <p style="text-align:center; color:#666; font-size:0.9em;">
            <!-- utilisation de value-of pour afficher le nom d'auteur -->
            Transcription et édition : <xsl:value-of select="//teiCorpus/teiHeader//titleStmt/author"/>
          </p>
          
          <!-- utilisation de value-of pour décrire le projet grâce aux balises publicationStmt et sourceDesc -->
          <div style="margin: 2em 0;">
            <h2>Présentation du projet</h2>
            <p>Ce projet d'édition numérique et de transformation porte sur trois lettres issues du fonds d'archives Jean-Michel et Nicole Thierry, conservé à l'Institut national d'histoire de l'art. 
              Ces trois lettres, dont les dates, les destinataires et les sujets varient, ont été choisies parce qu'elles illustrent la diversité des activités et des réseaux du chercheur au cours des 
              années 1970 et 1980 dans le domaine des études caucasiennes.
              Le contenu de ces lettres, à la fois privé et professionnel, est riche en références aux personnes, lieux, événements et objets au cœur de l'étude du patrimoine caucasien et constituent 
              encore aujourd'hui des témoins historiographiques précieux. En encodant ces lettres, j'ai souhaité poser les bases d'un index de ces entités en proposant un premier effort de vue d'ensemble des 
              acteurs, lieux et organisations qui se trouvent derrière la production scientifique de cette période. 
              Un argument supplémentaire peut-être avancé sur la nécessité de sauvegarde de ce patrimoine, généralement menacé et parfois systématiquement détruit selon les régions, et qui rend pertinentes 
              l'exploration et la publication de toute source relative à ces monuments.</p>
            <xsl:for-each select="//teiCorpus/teiHeader//publicationStmt/p">
              <p><xsl:value-of select="."/></p>
            </xsl:for-each>
            <xsl:for-each select="//teiCorpus/teiHeader//sourceDesc/p">
              <p><xsl:value-of select="."/></p>
            </xsl:for-each>
          </div>
          
          <!-- bloc d'information sur le fonds -->
          <div style="margin: 2em 0; border-left: 3px solid #bbb; padding-left: 1em;">
            <h2>Informations sur le fonds</h2>
            <p><strong>Institution :</strong> Institut national d'histoire de l'art</p>
            <p><strong>Éditeur :</strong>
              <xsl:value-of select="//teiCorpus/teiHeader//titleStmt/editor"/>
            </p>
            <p><strong>Nombre de lettres :</strong>
              <!-- ajout d'un select count pour afficher le nombre de lettres -->
              <xsl:value-of select="count(//teiCorpus/TEI)"/>
            </p>
          </div>
          
          <!-- création d'une boucle for-each qui part des balises TEI pour créer une liste  -->
          <div style="margin: 2em 0;">
            <h2>Lettres disponibles</h2>
            <ul class="lettre-list">
              <xsl:for-each select="//teiCorpus/TEI">
                <li>
                  <!-- les lettres ne sont pas codées en dur donc document évolutif  -->
                  <a href="{@xml:id}.html">
                    <xsl:value-of select=".//fileDesc/titleStmt/title"/>
                  </a>
                </li>
              </xsl:for-each>
            </ul>
          </div>
          
        </body>
        <xsl:copy-of select="$footer"/>
      </html>
    </xsl:result-document>
  </xsl:template>

<!-- template appelé plus haut : page-lettre -->
  <xsl:template name="page-lettre">
    <xsl:param name="lettre"/>
    <xsl:result-document href="out/{$lettre/@xml:id}.html" method="html" indent="yes">
      <html>
        <xsl:copy-of select="$head"/>
        <body>
          <xsl:call-template name="navbar"/>

          <!-- titre -->
          <h1><xsl:value-of select="$lettre//fileDesc/titleStmt/title"/></h1>

          <!-- récupération des métadonnées des lettres : utilisation de xsl:if pour agréger toutes les informations sur les émetteurs et destinataires -->
          <div class="lettre-meta">
            <p>
              <strong>De :</strong>&#160;
              <xsl:value-of select="string-join($lettre//correspAction[@type='sent']/persName, ', ')"/>
              <xsl:if test="$lettre//correspAction[@type='sent']/orgName">
                &#160;(<xsl:value-of select="$lettre//correspAction[@type='sent']/orgName"/>)
              </xsl:if>
            </p>
            <p>
              <strong>À :</strong>&#160;
              <xsl:value-of select="string-join($lettre//correspAction[@type='received']/persName, ', ')"/>
            </p>
            <p>
              <strong>Date :</strong>&#160;
              <xsl:value-of select="$lettre//correspAction[@type='sent']/date"/>
            </p>
            <p>
              <strong>Envoyé de :</strong>&#160;
              <xsl:value-of select="$lettre//correspAction[@type='sent']/placeName"/>
            </p>
          </div>

          <!-- corps du texte : rien à mettre en forme particulièrement -->
          <div class="lettre-body">
            <xsl:apply-templates select="$lettre//text/body"/>
          </div>

          <!-- La question des index est centrale dans mon projet : l'édition des lettres doit permettre une prosopographie du réseau des Thierry, utilisation 
            de la balise particDesc et listPlace
          dans le fichier XML originel donc mise en forme nécessaire avec un xsl:for-each -->
          <!-- Index des personnes -->
          <xsl:if test="$lettre//particDesc/listPerson/person">
            <div>
              <h2>Index des personnes</h2>
              <table class="index-table">
                <tr>
                  <th>Nom</th>
                  <th>Note</th>
                  <th>Identifiant</th>
                </tr>
                <xsl:for-each select="$lettre//particDesc/listPerson/person">
                  <tr>
                    <td><xsl:value-of select="persName"/></td>
                    <td><xsl:value-of select="note"/></td>
                    <td>
                      <xsl:if test="idno">
                        <xsl:value-of select="idno/@type"/> : <xsl:value-of select="idno"/>
                      </xsl:if>
                    </td>
                  </tr>
                </xsl:for-each>
              </table>
            </div>
          </xsl:if>

          <!-- Index des lieux -->
          <xsl:if test="$lettre//settingDesc/listPlace/place">
            <div>
              <h2>Index des lieux</h2>
              <table class="index-table">
                <tr>
                  <th>Lieu</th>
                  <th>Note</th>
                  <th>Identifiant</th>
                </tr>
                <xsl:for-each select="$lettre//settingDesc/listPlace/place">
                  <tr>
                    <td><xsl:value-of select="placeName"/></td>
                    <td><xsl:value-of select="note"/></td>
                    <td>
                      <xsl:if test="idno">
                        <xsl:value-of select="idno/@type"/> : <xsl:value-of select="idno"/>
                      </xsl:if>
                    </td>
                  </tr>
                </xsl:for-each>
              </table>
            </div>
          </xsl:if>

          <!-- Index des organisations -->
          <xsl:if test="$lettre//particDesc/listOrg/org">
            <div>
              <h2>Index des organisations </h2>
              <table class="index-table">
                <tr>
                  <th>Organisation</th>
                  <th>Note</th>
                  <th>Identifiant</th>
                </tr>
                <xsl:for-each select="$lettre//particDesc/listOrg/org">
                  <tr>
                    <td><xsl:value-of select="orgName"/></td>
                    <td><xsl:value-of select="note"/></td>
                    <td>
                      <xsl:if test="idno">
                        <xsl:value-of select="idno/@type"/> : <xsl:value-of select="idno"/>
                      </xsl:if>
                    </td>
                  </tr>
                </xsl:for-each>
              </table>
            </div>
          </xsl:if>

        </body>
        <xsl:copy-of select="$footer"/>
      </html>
    </xsl:result-document>
  </xsl:template>


  <!-- ============================================================ -->
  <!--  RÈGLES POUR LE CORPS DE LA LETTRE                          -->
  <!-- ============================================================ -->

  <xsl:template match="body">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="head">
    <div class="lettre-entete">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="p">
    <p><xsl:apply-templates/></p>
  </xsl:template>

  <!-- Listes (syllogisme / énumération) -->
  <xsl:template match="list">
    <ul style="margin: 0.5em 0 0.5em 1.5em;">
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="item">
    <li><xsl:apply-templates/></li>
  </xsl:template>

  <!-- Noms de personnes : mise en évidence légère -->
  <xsl:template match="persName">
    <span style="font-style: italic;"><xsl:apply-templates/></span>
  </xsl:template>

  <!-- Noms de lieux : soulignement léger -->
  <xsl:template match="placeName">
    <span style="text-decoration: underline dotted;"><xsl:apply-templates/></span>
  </xsl:template>

  <!-- Noms d'organisations : petites majuscules -->
  <xsl:template match="orgName">
    <span style="font-variant: small-caps;"><xsl:apply-templates/></span>
  </xsl:template>

  <!-- Date dans le corps -->
  <xsl:template match="text//date">
    <span style="color: #555;"><xsl:apply-templates/></span>
  </xsl:template>

</xsl:stylesheet>
