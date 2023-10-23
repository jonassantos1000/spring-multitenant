package br.com.app.conatus.service;

import java.util.List;

import org.springframework.stereotype.Service;

import br.com.app.conatus.entities.DominioEntity;
import br.com.app.conatus.enums.CodigoDominio;
import br.com.app.conatus.infra.exceptions.NaoEncontradoException;
import br.com.app.conatus.model.factory.DominioResponseFactory;
import br.com.app.conatus.model.response.DominioResponse;
import br.com.app.conatus.repositories.DominioRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DominioService {
	
	private final DominioRepository dominioRepository;
	
	protected DominioEntity recuperarPorId(Long id) {
		return dominioRepository.findById(id).orElseThrow(
				() -> new NaoEncontradoException("Não foi encontrado um dominio com id: %d".formatted(id)));
	}
	
	protected DominioEntity recuperarPorCodigo(String codigo) {
		return dominioRepository.findByCodigo(codigo).orElseThrow(
				() -> new NaoEncontradoException("Não foi encontrado um dominio com codigo: %s".formatted(codigo)));
	}
	
	public DominioEntity recuperarPorCodigo(CodigoDominio codigo) {
		return recuperarPorCodigo(codigo.name());
	}

	public DominioResponse buscarDominioPorId(Long id) {
		return DominioResponseFactory.converterParaResponse(recuperarPorId(id));
	}
	
	public DominioResponse buscarDominioPorCodigo(String codigo) {
		return DominioResponseFactory.converterParaResponse(recuperarPorCodigo(codigo));
	}

	public List<DominioResponse> buscarDominioPorCodigoTipo(String codTipo) {
		return dominioRepository.findByTipoCodigo(codTipo).stream().map(DominioResponseFactory::converterParaResponse)
				.toList();
	}

	public List<DominioResponse> buscarDominioPorIdTipo(Long idTipo) {
		return dominioRepository.findByTipoId(idTipo).stream().map(DominioResponseFactory::converterParaResponse)
				.toList();
	}

}
