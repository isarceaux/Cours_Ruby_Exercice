class Personne
  attr_accessor :nom, :points_de_vie, :en_vie

  def initialize(nom)
    @nom = nom
    @points_de_vie = 100
    @en_vie = true
  end

  def info
    if en_vie
      nom + " (#{points_de_vie}/100)"
    else
      nom + (" (vaincu)")
    end
  end

  def attaque(personne)
    shoot = degats
    puts nom + " attaque " + personne.nom
    personne.subit_attaque(shoot)
  end

  def subit_attaque(degats_recus)
    @points_de_vie = (points_de_vie - degats_recus)
    puts nom + " subit #{degats_recus} pv de dégats !"
    if @points_de_vie <= 0
      @en_vie = false
    else
      @en_vie = true
    end
  end
end

class Joueur < Personne
  attr_accessor :degats_bonus

  def initialize(nom)
    # Par défaut le joueur n'a pas de dégats bonus
    @degats_bonus = 0

    # Appelle le "initialize" de la classe mère (Personne)
    super(nom)
  end

  def degats
    degats_de_base = 1 #A modifier par la suite
    degats_aleatoires = rand(15)
    puts "Cause #{degats_de_base + degats_aleatoires + degats_bonus} de dégâts !"
    return (degats_de_base + degats_aleatoires + degats_bonus)
  end

  def soin
    @points_de_vie += 5
    puts @nom + " se soigne et vient de re-gagner de la vie !"
  end

  def ameliorer_degats
    @degats_bonus += 15
    puts @nom + " vient d'augmenter sa fooooorce !!"
  end
end

class Ennemi < Personne
  def degats
    degats_de_base = 1 #A modifier par la suite
    degats_aleatoires = rand(5)
    return (degats_de_base + degats_aleatoires)
  end
end

class Jeu
  def self.actions_possibles(monde)
    puts "ACTIONS POSSIBLES :"

    puts "0 - Se soigner"
    puts "1 - Améliorer son attaque"

    # On commence à 2 car 0 et 1 sont réservés pour les actions
    # de soin et d'amélioration d'attaque
    i = 2
    monde.ennemis.each do |ennemi|
      puts "#{i} - Attaquer #{ennemi.info}"
      i = i + 1
    end
    puts "99 - Quitter"
  end

  def self.est_fini(joueur, monde)
    if joueur.points_de_vie <= 0 
      return true
    elsif monde.ennemis_en_vie.size == 0
      return true
    else
      return false
    end
  end
end

class Monde
  attr_accessor :ennemis

  def ennemis_en_vie
    ennemis_en_vie=[]
    @ennemis.each do |mechant|
      if mechant.points_de_vie >0
        ennemis_en_vie << mechant
      end
    end
    return ennemis_en_vie
  end

end

##############

# Initialisation du monde
monde = Monde.new

# Ajout des ennemis
monde.ennemis = [
  Ennemi.new("Balrog"),
  Ennemi.new("Goblin"),
  Ennemi.new("Squelette")
]

# Initialisation du joueur
joueur = Joueur.new("Jean-Michel Paladin")
exit = true

# Message d'introduction. \n signifie "retour à la ligne"
puts "\n\nAinsi débutent les aventures de #{joueur.nom}\n\n"


# Boucle de jeu principale
100.times do |tour|
  puts "\n------------------ Tour numéro #{tour} ------------------"

  # Affiche les différentes actions possibles
  Jeu.actions_possibles(monde)

  puts "\nQUELLE ACTION FAIRE ?"
  # On range dans la variable "choix" ce que l'utilisateur renseigne
  choix = gets.chomp.to_i

  # En fonction du choix on appelle différentes méthodes sur le joueur
  if choix == 0
    joueur.soin
  elsif choix == 1
    joueur.ameliorer_degats
  elsif choix == 99
    exit = false
    # On quitte la boucle de jeu si on a choisi
    # 99 qui veut dire "quitter"
    break
  else
    # Choix - 2 car nous avons commencé à compter à partir de 2
    # car les choix 0 et 1 étaient réservés pour le soin et
    # l'amélioration d'attaque
    ennemi_a_attaquer = monde.ennemis[choix - 2]
    joueur.attaque(ennemi_a_attaquer)
  end

  puts "\nLES ENNEMIS RIPOSTENT !"
  # Pour tous les ennemis en vie ...
  monde.ennemis_en_vie.each do |ennemi|
    # ... le héro subit une attaque.
    ennemi.attaque(joueur)
  end

  puts "\nEtat du héro: #{joueur.info}\n"

  # Si le jeu est fini, on interompt la boucle
  break if Jeu.est_fini(joueur, monde)
end

puts "\nFin du jeu !\n"

# A faire:
# - Afficher le résultat de la partie
puts ""
puts "Le résultat de la partie est le suivant :"
puts "- " + joueur.info
monde.ennemis.each do |mechant|
  puts "- " + mechant.info
end


if joueur.en_vie && exit
  puts ""
  puts"Donc..."
  puts "Vous avez gagné !"
elsif joueur.en_vie == false && exit == true
  puts ""
  puts"Donc..."
  puts "Vous avez perdu !"
else
  puts ""
  puts "Mais fallait pas quiter :'-("
end