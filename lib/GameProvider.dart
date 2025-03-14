import 'package:flutter/material.dart';
import 'cards.dart';

class GameProvider {
    List<Cards> cards = [];
    List<Cards> selectedCards = [];
    List<Cards> matchedCards = [];
    int moves = 0;
    int score = 0;
    bool isGameOver = false;
    bool isMatch = false;

    GameProvider({
        required this.cards,
    });

  void resetGame(){
    cards = [];
    selectedCards = [];
    matchedCards = [];
    moves = 0;
    score = 0;
    isGameOver = false;
  }

  void updateScore(bool isMatch){
    if(isMatch){
      score += 10;
    }else{
      score -= 5;
    }
  }

  void selectCard(Cards card){
    if(selectedCards.length < 2){
      selectedCards.add(card);
    }
  }

  void checkMatch(){
    moves += 1;
    if(selectedCards[0] == selectedCards[1]){
      matchedCards.add(selectedCards[0]);
      selectedCards[0].freezeCard();
      matchedCards.add(selectedCards[1]);
      selectedCards[1].freezeCard();
      isMatch = true;
    }else{
      isMatch = false;
    }
  }

  void checkGameOver(){
    if(matchedCards.length == cards.length){
      isGameOver = true;
    }
  }

  void freezeCards(cards){
    for(Cards card in cards){
      if(card.original_id != selectedCards[0].original_id && 
         card.original_id != selectedCards[1].original_id){
        card.freezeCard();
      }
    }
  }

  void unfreezeCards(cards){
    for(Cards card in cards){
      if(!matchedCards.contains(card)){
        card.unfreezeCard();
      }
    }
  }

  bool get getIsMatch => isMatch;
}