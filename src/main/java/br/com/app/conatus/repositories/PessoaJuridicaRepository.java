package br.com.app.conatus.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import br.com.app.conatus.commons.entities.PessoaJuridicaEntity;

@Repository
public interface PessoaJuridicaRepository extends JpaRepository<PessoaJuridicaEntity, Long>{

	boolean existsByCnpj(String cpf);

}
